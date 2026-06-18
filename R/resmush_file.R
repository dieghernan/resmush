#' Optimize local image files
#'
#' @description
#' Optimize one or more local image files with the
#' [reSmush.it API](https://resmush.it/api/). The API is free for personal use
#' and accepts files smaller than 5 MB.
#'
#' @param file A character vector of paths to local image files. The API can
#'   optimize PNG, JPEG, GIF, BMP and TIFF files.
#'
#' @param suffix A character string inserted before each output file extension.
#'   The default is `"_resmush"`, so `example.png` becomes
#'   `example_resmush.png`. Values `""`, `NA` and `NULL` are equivalent to
#'   `overwrite = TRUE`.
#' @param overwrite Logical. Should the input files be overwritten? If `TRUE`,
#'   `suffix` is ignored.
#' @param progress Logical. Should a progress bar be displayed?
#' @param report Logical. Should a summary report be displayed in the console?
#' @param qlty An integer between `0` and `100` indicating the optimization
#'   level. This only affects JPEG files. For optimal results, use values above
#'   `90`.
#' @param exif_preserve Logical. Should
#'   [EXIF](https://en.wikipedia.org/wiki/Exif) metadata be preserved? The
#'   default is `FALSE`, which removes it.
#'
#' @returns
#' A data frame with source and destination paths, file sizes, compression
#' ratios and status notes, returned invisibly. Successful API calls also write
#' the optimized files to disk. If `report = TRUE`, a summary is displayed in
#' the console.
#'
#' @seealso
#' [reSmush.it API](https://resmush.it/api/) documentation.
#'
#' See [resmush_clean_dir()] to clean a directory of previous runs.
#'
#' @family optimize
#' @export
#' @encoding UTF-8
#' @examplesIf httr2::is_online()
#'
#' \donttest{
#' png_file <- system.file("extimg/example.png", package = "resmush")
#'
#' # Copy to a temporary file for this example.
#' tmp_png <- tempfile(fileext = ".png")
#'
#' file.copy(png_file, tmp_png, overwrite = TRUE)
#'
#' resmush_file(tmp_png)
#'
#' # Optimize multiple files.
#' jpg_file <- system.file("extimg/example.jpg", package = "resmush")
#' tmp_jpg <- tempfile(fileext = ".jpg")
#'
#' file.copy(jpg_file, tmp_jpg, overwrite = TRUE)
#'
#' # Display a summary in the console.
#' summary <- resmush_file(c(tmp_png, tmp_jpg))
#'
#' # Inspect the returned optimization summary.
#' summary
#'
#' # Display the PNG output.
#' if (require("png", quietly = TRUE)) {
#'   my_png <- png::readPNG(summary$dest_img[1])
#'   grid::grid.raster(my_png)
#' }
#'
#' # Adjust the optimization level for a JPEG file.
#' resmush_file(tmp_jpg)
#' resmush_file(tmp_jpg, qlty = 10)
#' }
#'
resmush_file <- function(
  file,
  suffix = "_resmush",
  overwrite = FALSE,
  progress = TRUE,
  report = TRUE,
  qlty = 92,
  exif_preserve = FALSE
) {
  res_df <- resmush_map(
    inputs = file,
    progress = progress,
    progress_label = "files",
    worker = function(i) {
      resmush_file_single(
        file[i],
        suffix = suffix,
        overwrite = overwrite,
        qlty = qlty,
        exif_preserve = exif_preserve
      )
    }
  )

  # Display the optional optimization report.
  if (report) {
    show_report(res_df = res_df)
  }

  invisible(res_df)
}

# Handle one local image file at a time.
resmush_file_single <- function(
  file,
  suffix = "_resmush",
  overwrite = FALSE,
  qlty = 92,
  exif_preserve = FALSE
) {
  outfile <- add_suffix(file, suffix, overwrite)
  res <- new_resmush_result(file)

  # Allow checks to simulate offline mode.
  test <- getOption("resmush_test_offline", FALSE)
  if (any(isFALSE(httr2::is_online()), test)) {
    res$notes <- "Offline"
    return(invisible(res))
  }
  if (!file.exists(file)) {
    res$notes <- "Local file does not exist"
    return(invisible(res))
  }

  src_size <- file.size(file)
  res$src_bytes <- src_size
  res$src_size <- make_pretty_size(src_size)

  res_post <- smush_from_local(file, qlty, exif_preserve)

  if ("error" %in% names(res_post)) {
    res$notes <- paste0(res_post$error, ": ", res_post$error_long)
    return(invisible(res))
  }

  # nocov start
  if (!"dest" %in% names(res_post)) {
    res$notes <- "API not responding, check https://resmush.it/status"
    return(invisible(res))
  }
  # nocov end

  dwn_opt <- download_optimized_file(
    url = res_post$dest,
    outfile = outfile,
    src = file,
    source_type = "file"
  )
  if (is.null(dwn_opt)) {
    return(NULL)
  }

  # Allow checks to simulate an invalid download response.
  test_corner <- getOption("resmush_test_corner", FALSE)
  if (any(httr2::resp_status(dwn_opt) != 200, test_corner)) {
    res$notes <- "API not responding, check https://resmush.it/status"
    return(invisible(res))
  }

  res$dest_img <- outfile

  res <- add_size_summary(
    res,
    src_size = src_size,
    dest_size = file.size(outfile)
  )

  invisible(res)
}

# Send a local image file to the API.
smush_from_local <- function(path, qlty, exif_preserve = TRUE) {
  # Normalize `exif_preserve` to a scalar logical.
  exif_preserve <- isTRUE(exif_preserve)

  api_url <- httr2::url_parse("http://api.resmush.it/")
  api_url$query <- list(qlty = qlty, exif = exif_preserve)
  api_url <- httr2::url_build(api_url)
  the_req <- httr2::request(api_url)
  the_req <- httr2::req_headers(
    the_req,
    referer = "https://dieghernan.github.io/resmush/"
  )
  the_req_file <- httr2::req_body_multipart(
    the_req,
    files = curl::form_file(path)
  )

  api_get <- httr2::req_perform(the_req_file)
  res_get <- httr2::resp_body_json(api_get)

  res_get
}
