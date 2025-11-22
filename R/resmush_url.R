#' Optimize an online file
#'
#' @description
#' Optimize and download an online image using the
#' [reSmush.it API](https://resmush.it/).
#'
#' @param url url or a vector of urls pointing to hosted image files.
#' **reSmush** can optimize the following image files:
#'  * `png`
#'  * `jpg/jpeg`
#'  * `gif`
#'  * `bmp`
#'  * `tiff`
#'
#' @param outfile Path or paths where the optimized files would be store in
#' your disk. By default, temporary files (see [tempfile()]) with the same
#' [basename()] than the file provided in `url` would be created. It should be
#' of the same length than `url` parameter.
#'
#' @param overwrite Logical. Should `outfile` be overwritten (if already
#'   exists)? If `FALSE` and `outfile` exists it would create a copy with
#'   a numerical suffix (i.e. `<outfile>.png`, `<outfile>_01.png`, etc.).
#'
#' @inheritParams resmush_file
#'
#' @return
#' Writes on disk the optimized file if the API call is successful.
#' In all cases, a (invisible) data frame with a summary of the process is
#' returned as well.
#'
#' If any value of the vector `outfile` is duplicated, `resmush_url()` would
#' rename the output with a suffix `_01. _02`, etc.
#'
#'
#' @seealso
#' [reSmush.it API](https://resmush.it/api/) docs.
#'
#' @family optimize
#'
#' @export
#'
#' @examplesIf curl::has_internet()
#'
#' \donttest{
#'
#' # Base url
#' base_url <- "https://raw.githubusercontent.com/dieghernan/resmush/main/inst/"
#'
#' png_url <- paste0(base_url, "/extimg/example.png")
#' resmush_url(png_url)
#'
#' # Several urls
#' jpg_url <- paste0(base_url, "/extimg/example.jpg")
#'
#'
#' summary <- resmush_url(c(png_url, jpg_url))
#'
#' # Returns an (invisible) data frame with a summary of the process
#' summary
#'
#' # Display with png
#' if (require("png", quietly = TRUE)) {
#'   my_png <- png::readPNG(summary$dest_img[1])
#'   grid::grid.raster(my_png)
#' }
#'
#' # Use with jpg and parameters
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
  # High level function for vectors

  # Check lengths
  l1 <- length(url)
  l2 <- length(outfile)

  if (l1 != l2) {
    cli::cli_abort(paste0(
      "Lengths of {.arg url} and {.arg outfile}",
      "should be the same  ({l1} vs. {l2})"
    ))
  }

  # Prepare progress bar
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
        "({cli::pb_current}/{cli::pb_total} urls)"
      ),
      total = n_urls,
      clear = FALSE
    )
  }

  # Call single with loop, cli::cli_progress_bar does not work on applys yet
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

    if (is.null(res_df)) {
      res_df <- df
    } else {
      res_df <- rbind(res_df, df)
    }
  }

  # restore options
  if (progress) {
    options(
      cli.progress_bar_style = opts$cli.progress_bar_style,
      cli.progress_show_after = opts$cli.progress_show_after,
      cli.spinner = opts$cli.spinner
    )
  }

  # report
  if (report) {
    show_report(res_df = res_df, summary_type = "url")
  }

  # output

  invisible(res_df)
}


resmush_url_single <- function(
  url,
  outfile = file.path(tempdir(), basename(url)),
  overwrite = FALSE,
  qlty = 92,
  exif_preserve = FALSE
) {
  # Avoid duplicates if requested
  outfile <- make_unique_paths(outfile, overwrite)

  # Create dir if it doesn't exists
  the_dir <- dirname(outfile)
  if (!dir.exists(the_dir)) {
    dir.create(the_dir, recursive = TRUE)
  }

  # Master table with results
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

  # Check access
  # Internal option, for checking purposes only
  test <- getOption("resmush_test_offline", FALSE)
  if (any(isFALSE(curl::has_internet()), test)) {
    res$notes <- "Offline"
    return(invisible(res))
  }

  # API Calls -----

  res_get <- smush_from_url(url, qlty, exif_preserve, n_rep = 3)

  if ("error" %in% names(res_get)) {
    res$notes <- paste0(res_get$error, ": ", res_get$error_long)
    return(invisible(res))
  }

  # nocov start
  if (!"dest" %in% names(res_get)) {
    res$notes <- "API Not responding, check https://resmush.it/status}"
    return(invisible(res))
  }
  # nocov end

  ##  2. Download from dest ----
  dwn_opt <- httr2::request(res_get$dest)

  # Finally
  dwn_opt <- httr2::req_perform(dwn_opt, path = outfile)

  # Corner case
  # Internal option, for checking purposes only
  test_corner <- getOption("resmush_test_corner", FALSE)
  if (any(httr2::resp_status(dwn_opt) != 200, test_corner)) {
    res$notes <- "API Not responding, check https://resmush.it/status}"
    return(invisible(res))
  }

  # Finally
  res$dest_img <- outfile

  src_size <- res_get$src_size
  src_size_pretty <- make_pretty_size(src_size)

  res$src_size <- src_size_pretty
  res$src_bytes <- src_size

  out_size <- file.size(outfile)
  out_size_pretty <- make_pretty_size(out_size)

  res$dest_size <- out_size_pretty
  res$dest_bytes <- out_size

  # Reduction ratio
  red_ratio <- 1 - out_size / src_size
  res$compress_ratio <- sprintf("%0.2f%%", red_ratio * 100)
  res$notes <- "OK"

  invisible(res)
}


# Helper function for retrying the call
# Useful for some cases e.g imgur
smush_from_url <- function(url, qlty, exif_preserve = TRUE, n_rep = 3) {
  # Make logical
  exif_preserve <- isTRUE(exif_preserve)

  api_url <- httr2::url_parse("http://api.resmush.it/ws.php")
  api_url$query <- list(
    qlty = qlty,
    exif = exif_preserve,
    img = url
  )
  api_url <- httr2::url_build(api_url)
  the_req <- httr2::request(api_url)

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
