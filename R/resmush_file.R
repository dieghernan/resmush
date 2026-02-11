#' Optimize a local file
#'
#' @description
#' Optimize local images using the [reSmush.it API](https://resmush.it/).
#'
#' @param file Path or paths to local files. **reSmush** can optimize the
#'  following image files:
#'  * `png`
#'  * `jpg/jpeg`
#'  * `gif`
#'  * `bmp`
#'  * `tiff`
#'
#' @param suffix Character, defaults to `"_resmush"`. By default, a new file
#'   with this `suffix` is created in the same directory as `file`. (i.e.,
#'   optimized `example.png` would be `example_resmush.png`). Values `""`, `NA`
#'   and `NULL` would be the same as `overwrite = TRUE`.
#' @param overwrite Logical. Should the file in `file` be overwritten? If `TRUE`
#'   `suffix` would be ignored.
#' @param progress Logical. Display a progress bar when needed.
#' @param report Logical. Display a summary report of the process in the
#'   console. See also **Value**.
#' @param qlty Only affects `jpg` files. Integer between `0` and `100`
#'   indicating the optimization level. For optimal results use values above
#'   `90`.
#' @param exif_preserve Logical. Should the
#'   [Exif](https://en.wikipedia.org/wiki/Exif) information (if any) be deleted?
#'   Default is to remove it (i.e. `exif_preserve = FALSE`).
#'
#' @return
#' Writes on disk the optimized file if the API call is successful in the
#' same directory as `file`.
#'
#' With the option `report = TRUE` a summary report is displayed in the
#' console. In all cases, an (`invisible()`) data frame with a summary of the
#' process used to generate the report is returned.
#'
#' @seealso
#' [reSmush.it API](https://resmush.it/api/) docs.
#'
#' See [resmush_clean_dir()] to clean a directory of previous runs.
#'
#' @family optimize
#' @encoding UTF-8
#' @export
#'
#' @examplesIf curl::has_internet()
#'
#' \donttest{
#' png_file <- system.file("extimg/example.png", package = "resmush")
#'
#' # For the example, copy to a temporary file
#' tmp_png <- tempfile(fileext = ".png")
#'
#' file.copy(png_file, tmp_png, overwrite = TRUE)
#'
#' resmush_file(tmp_png)
#'
#' # Several paths
#' jpg_file <- system.file("extimg/example.jpg", package = "resmush")
#' tmp_jpg <- tempfile(fileext = ".jpg")
#'
#' file.copy(jpg_file, tmp_jpg, overwrite = TRUE)
#'
#' # Output summary in console
#' summary <- resmush_file(c(tmp_png, tmp_jpg))
#'
#' # Similar info in an (invisible) data frame as a result
#' summary
#'
#' # Display with png
#' if (require("png", quietly = TRUE)) {
#'   my_png <- png::readPNG(summary$dest_img[1])
#'   grid::grid.raster(my_png)
#' }
#'
#' # With parameters
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
  # Prepare progress bar
  n_files <- length(file)
  n_seq <- seq_len(n_files)

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
        "({cli::pb_current}/{cli::pb_total} files)"
      ),
      total = n_files,
      clear = FALSE
    )
  }
  # Call single with loop, cli::cli_progress_bar does not work on applys yet
  res_df <- NULL

  for (i in n_seq) {
    if (progress) {
      cli::cli_progress_update()
    }

    df <- resmush_file_single(
      file[i],
      suffix = suffix,
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
    show_report(res_df = res_df)
  }

  # output

  invisible(res_df)
}


# Single call
resmush_file_single <- function(
  file,
  suffix = "_resmush",
  overwrite = FALSE,
  qlty = 92,
  exif_preserve = FALSE
) {
  outfile <- add_suffix(file, suffix, overwrite)
  # Master table with results
  res <- data.frame(
    src_img = file,
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
  # Check if file
  if (!file.exists(file)) {
    res$notes <- "Local file does not exists"
    return(invisible(res))
  }

  # Initial call to size in disk
  src_size <- file.size(file)
  res$src_bytes <- src_size
  res$src_size <- make_pretty_size(src_size)

  # API Calls -----
  ## 1. Send local file -----

  res_post <- smush_from_local(file, qlty, exif_preserve)

  if ("error" %in% names(res_post)) {
    res$notes <- paste0(res_post$error, ": ", res_post$error_long)
    return(invisible(res))
  }

  # nocov start
  if (!"dest" %in% names(res_post)) {
    res$notes <- "API Not responding, check https://resmush.it/status}"
    return(invisible(res))
  }
  # nocov end

  ##  2. Download from dest ----
  dwn_opt <- httr2::request(res_post$dest)
  dwn_opt <- httr2::req_headers(
    dwn_opt,
    referer = "https://dieghernan.github.io/resmush/"
  )

  # First dry-run
  req_head <- httr2::req_method(dwn_opt, "HEAD")
  req_head <- httr2::req_error(req_head, is_error = function(x) {
    FALSE
  })
  resp_head <- httr2::req_perform(req_head)
  test_no_file <- getOption("resmush_test_no_file", FALSE)
  if (any(httr2::resp_is_error(resp_head), test_no_file)) {
    # Get code and error and return NULL
    err_code <- httr2::resp_status(resp_head) # nolint
    err <- httr2::resp_status_desc(resp_head) # nolint
    cli::cli_alert_danger("HTTP {err_code} {err} for file:\n {.path {file}}")
    return(NULL)
  }

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

  out_size <- file.size(outfile)
  res$dest_bytes <- out_size
  res$dest_size <- make_pretty_size(out_size)

  # Reduction ratio
  red_ratio <- 1 - out_size / src_size
  res$compress_ratio <- sprintf("%0.2f%%", red_ratio * 100)
  res$notes <- "OK"

  invisible(res)
}


# Helper function for retrying the call
smush_from_local <- function(path, qlty, exif_preserve = TRUE) {
  # Make logical
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
