#' Optimize an online image
#'
#' @description
#' Optimize and download an online image using the
#' [reSmush.it API](https://resmush.it/).
#'
#' @param url URL or vector of URLs pointing to hosted image files. **reSmush**
#'   can optimize `png`, `jpg/jpeg`, `gif`, `bmp` and `tiff` files.
#'
#' @param outfile Path or paths where optimized files are stored on disk. By
#'   default, temporary files (see [tempfile()]) with the same [basename()] as
#'   the file provided in `url` are created. `outfile` must have the same length
#'   as `url`.
#'
#' @param overwrite Logical. Should `outfile` be overwritten if it already
#'   exists? If `FALSE` and `outfile` exists, a copy is created with a
#'   numerical suffix (i.e. `<outfile>.png`, `<outfile>_01.png`, etc.).
#'
#' @inheritParams resmush_file
#'
#' @return
#' Writes the optimized file to disk if the API call is successful. In all
#' cases, an [invisible()] data frame summarizing the process is returned.
#'
#' If any value of the vector `outfile` is duplicated, `resmush_url()` renames
#' the output with suffixes such as `_01`, `_02`, etc.
#'
#' @seealso
#' [reSmush.it API](https://resmush.it/api/) docs.
#'
#' @family optimize
#'
#' @export
#' @encoding UTF-8
#' @examplesIf curl::has_internet()
#'
#' \donttest{
#'
#' # Base URL.
#' base_url <- "https://raw.githubusercontent.com/dieghernan/resmush/main/inst/"
#'
#' png_url <- paste0(base_url, "/extimg/example.png")
#' resmush_url(png_url)
#'
#' # Several URLs.
#' jpg_url <- paste0(base_url, "/extimg/example.jpg")
#'
#' summary <- resmush_url(c(png_url, jpg_url))
#'
#' # Return an invisible data frame with a summary of the process.
#' summary
#'
#' # Display the PNG output.
#' if (require("png", quietly = TRUE)) {
#'   my_png <- png::readPNG(summary$dest_img[1])
#'   grid::grid.raster(my_png)
#' }
#'
#' # Use with JPG and parameters.
#' resmush_url(jpg_url)
#' resmush_url(jpg_url, qlty = 10)
#' }
resmush_url <- function(
  url,
  outfile = file.path(tempdir(), basename(url)),
  overwrite = FALSE,
  progress = TRUE,
  report = TRUE,
  qlty = 92,
  exif_preserve = FALSE
) {
  # Handle vectorized URL input.

  # Ensure `url` and `outfile` have matching lengths.
  l1 <- length(url)
  l2 <- length(outfile)

  if (l1 != l2) {
    cli::cli_abort(paste0(
      "Lengths of {.arg url} and {.arg outfile} ",
      "should be the same ({l1} vs. {l2})"
    ))
  }

  # Prepare progress bar.
  n_urls <- l1
  n_seq <- seq_len(n_urls)

  if (progress) {
    opts <- options()
    options(
      cli.progress_bar_style = "fillsquares",
      cli.progress_show_after = 0,
      cli.spinner = "clock"
    )

    cli::cli_progress_bar(
      format = paste0(
        "{cli::pb_spin} Go! | {cli::pb_bar} ",
        "{cli::pb_percent} [{cli::pb_elapsed}] | ETA: {cli::pb_eta} ",
        "({cli::pb_current}/{cli::pb_total} URLs)"
      ),
      total = n_urls,
      clear = FALSE
    )
  }

  # Call `resmush_url_single()` in a loop.
  # cli::cli_progress_bar() does not work with apply-family calls yet.
  res_df <- NULL

  for (i in n_seq) {
    if (progress) {
      cli::cli_progress_update()
    }

    df <- resmush_url_single(
      url = url[i],
      outfile = outfile[i],
      overwrite = overwrite,
      qlty = qlty,
      exif_preserve = exif_preserve
    )

    if (is.null(df)) {
      next
    }

    if (is.null(res_df)) {
      res_df <- df
    } else {
      res_df <- rbind(res_df, df)
    }
  }

  # Restore options.
  if (progress) {
    options(
      cli.progress_bar_style = opts$cli.progress_bar_style,
      cli.progress_show_after = opts$cli.progress_show_after,
      cli.spinner = opts$cli.spinner
    )
  }

  # Display report.
  if (report) {
    show_report(res_df = res_df, summary_type = "url")
  }

  # Return output.
  invisible(res_df)
}

resmush_url_single <- function(
  url,
  outfile = file.path(tempdir(), basename(url)),
  overwrite = FALSE,
  qlty = 92,
  exif_preserve = FALSE
) {
  # Avoid overwriting existing output paths unless requested.
  outfile <- make_unique_paths(outfile, overwrite)

  # Create the output directory if it does not exist.
  the_dir <- dirname(outfile)
  if (!dir.exists(the_dir)) {
    dir.create(the_dir, recursive = TRUE)
  }

  # Create the results table.
  res <- data.frame(
    src_img = url,
    dest_img = NA,
    src_size = NA,
    dest_size = NA,
    compress_ratio = NA,
    notes = NA,
    src_bytes = NA,
    dest_bytes = NA
  )

  # Check internet access.
  # Internal option, for checking purposes only.
  test <- getOption("resmush_test_offline", FALSE)
  if (any(isFALSE(curl::has_internet()), test)) {
    res$notes <- "Offline"
    return(invisible(res))
  }

  # API calls -----

  res_get <- smush_from_url(url, qlty, exif_preserve, n_rep = 3)

  if ("error" %in% names(res_get)) {
    res$notes <- paste0(res_get$error, ": ", res_get$error_long)
    return(invisible(res))
  }

  # nocov start
  if (!"dest" %in% names(res_get)) {
    res$notes <- "API not responding, check https://resmush.it/status"
    return(invisible(res))
  }
  # nocov end

  ## 2. Download from destination URL -----
  dwn_opt <- httr2::request(res_get$dest)

  dwn_opt <- httr2::req_headers(
    dwn_opt,
    referer = "https://dieghernan.github.io/resmush/"
  )

  # Check whether the optimized file can be downloaded.
  req_head <- httr2::req_method(dwn_opt, "HEAD")
  req_head <- httr2::req_error(req_head, is_error = function(x) {
    FALSE
  })
  resp_head <- httr2::req_perform(req_head)
  test_no_file <- getOption("resmush_test_no_file", FALSE)
  if (any(httr2::resp_is_error(resp_head), test_no_file)) {
    # Get the status code and error, then return `NULL`.
    err_code <- httr2::resp_status(resp_head) # nolint
    err <- httr2::resp_status_desc(resp_head) # nolint
    cli::cli_alert_danger("HTTP {err_code} {err} for URL:\n {.url {url}}")
    return(NULL)
  }

  # Download the optimized file.
  dwn_opt <- httr2::req_perform(dwn_opt, path = outfile)

  # Handle failed optimized-file downloads.
  # Internal option, for checking purposes only.
  test_corner <- getOption("resmush_test_corner", FALSE)
  if (any(httr2::resp_status(dwn_opt) != 200, test_corner)) {
    res$notes <- "API not responding, check https://resmush.it/status"
    return(invisible(res))
  }

  # Store the output path.
  res$dest_img <- outfile

  src_size <- res_get$src_size
  src_size_pretty <- make_pretty_size(src_size)

  res$src_size <- src_size_pretty
  res$src_bytes <- src_size

  out_size <- file.size(outfile)
  out_size_pretty <- make_pretty_size(out_size)

  res$dest_size <- out_size_pretty
  res$dest_bytes <- out_size

  # Compute the compression ratio.
  red_ratio <- 1 - out_size / src_size
  res$compress_ratio <- sprintf("%0.2f%%", red_ratio * 100)
  res$notes <- "OK"

  invisible(res)
}

# Helper function for retrying the URL API call.
# Useful for some cases, such as imgur.
smush_from_url <- function(url, qlty, exif_preserve = TRUE, n_rep = 3) {
  # Normalize `exif_preserve` to a scalar logical.
  exif_preserve <- isTRUE(exif_preserve)

  api_url <- httr2::url_parse("http://api.resmush.it/ws.php")
  api_url$query <- list(qlty = qlty, exif = exif_preserve, img = url)
  api_url <- httr2::url_build(api_url)
  the_req <- httr2::request(api_url)
  the_req <- httr2::req_headers(
    the_req,
    referer = "https://dieghernan.github.io/resmush/"
  )

  for (i in seq(1, n_rep)) {
    api_get <- httr2::req_perform(the_req)
    res_get <- httr2::resp_body_json(api_get)
    if (!"error" %in% names(res_get)) {
      break
    }
    Sys.sleep(0.5)
  }
  res_get
}
