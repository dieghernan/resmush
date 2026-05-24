#' Optimize online image files
#'
#' @description
#' Optimize and download one or more online image files with the
#' [reSmush.it API](https://resmush.it/).
#'
#' @param url URL or vector of URLs pointing to hosted image files. The API can
#'   optimize `png`, `jpg/jpeg`, `gif`, `bmp` and `tiff` files.
#'
#' @param outfile Path or paths where optimized files are stored on disk. By
#'   default, temporary files are created with [tempfile()] and the same
#'   [basename()] as the file provided in `url`. `outfile` must have the same
#'   length as `url`.
#'
#' @param overwrite Logical. Should `outfile` be overwritten if it already
#'   exists? If `FALSE` and `outfile` exists, a copy is created with a
#'   numerical suffix, such as `<outfile>_01.png`.
#'
#' @inheritParams resmush_file
#'
#' @return
#' Writes optimized files to disk when the API call is successful. Invisibly
#' returns a data frame summarizing the process. If any value in `outfile` is
#' duplicated, `resmush_url()` renames the outputs with suffixes such as `_01`
#' and `_02`.
#'
#' @seealso
#' [reSmush.it API](https://resmush.it/api/) documentation.
#'
#' @family optimize
#' @export
#' @encoding UTF-8
#' @examplesIf curl::has_internet()
#'
#' \donttest{
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
#' # The invisible data frame contains a summary of the process.
#' summary
#'
#' # Display the `png` output.
#' if (require("png", quietly = TRUE)) {
#'   my_png <- png::readPNG(summary$dest_img[1])
#'   grid::grid.raster(my_png)
#' }
#'
#' # Use with `jpg` files and parameters.
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
  # Ensure `url` and `outfile` have matching lengths.
  l1 <- length(url)
  l2 <- length(outfile)

  if (l1 != l2) {
    cli::cli_abort(paste0(
      "Lengths of {.arg url} and {.arg outfile} must match ",
      "({l1} vs. {l2})."
    ))
  }

  res_df <- resmush_map(
    inputs = url,
    progress = progress,
    progress_label = "URLs",
    worker = function(i) {
      resmush_url_single(
        url = url[i],
        outfile = outfile[i],
        overwrite = overwrite,
        qlty = qlty,
        exif_preserve = exif_preserve
      )
    }
  )

  # Display the optional optimization report.
  if (report) {
    show_report(res_df = res_df, summary_type = "url")
  }

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

  res <- new_resmush_result(url)

  # Internal option, for checking purposes only.
  test <- getOption("resmush_test_offline", FALSE)
  if (any(isFALSE(curl::has_internet()), test)) {
    res$notes <- "Offline"
    return(invisible(res))
  }

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

  dwn_opt <- download_optimized_file(
    url = res_get$dest,
    outfile = outfile,
    src = url,
    source_type = "url"
  )
  if (is.null(dwn_opt)) {
    return(NULL)
  }

  # Internal option, for checking purposes only.
  test_corner <- getOption("resmush_test_corner", FALSE)
  if (any(httr2::resp_status(dwn_opt) != 200, test_corner)) {
    res$notes <- "API not responding, check https://resmush.it/status"
    return(invisible(res))
  }

  res$dest_img <- outfile

  res <- add_size_summary(
    res,
    src_size = res_get$src_size,
    dest_size = file.size(outfile)
  )

  invisible(res)
}

# Retry the URL API call for hosts that need more than one attempt.
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
