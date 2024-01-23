#' Optimize a local file
#'
#' @description
#' Optimize local images using the [reSmush.it API](https://resmush.it/).
#'
#'
#' @param file Path or paths to local files. **reSmush** can optimize the
#'  following image files:
#'  * `png`
#'  * `jpg/jpeg`
#'  * `gif`
#'  * `bmp`
#'  * `tiff`
#'  * `webp`
#'
#' @param suffix Character, defaults to `"_resmush"`. By default, a new file
#'   with the suffix is created in the same directory than `file`. (i.e.,
#'   optimized `example.png` would be `example_resmush.png`). Use `""`, `NA`
#'   of `NULL` for overwrite the initial `file`.
#'   the `file` use any of the following values: `"", NA, NULL`.
#' @param qlty Only affects `jpg` files. Integer between 0 and 100 indicating
#' the optimization level. For optimal results use vales above 90.
#' @param verbose Logical. If `TRUE` displays a summary of the results.
#' @param exif_preserve Logical. Should the
#'   [Exif](https://en.wikipedia.org/wiki/Exif) information (if any) deleted?
#'   Default is to remove (i.e. `exif_preserve = FALSE`).
#' @return
#' Writes on disk the optimized file if the API call is successful in the
#' same directory than `file`.
#' In any case, a (invisibly) data frame with a summary of the process is
#' returned as well.
#'
#' @seealso
#' [reSmush.it API](https://resmush.it/api) docs.
#'
#' See [resmush_clean_dir()] to clean a directory of previous runs.
#'
#' @family optimize
#'
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
#' summary <- resmush_file(c(tmp_png, tmp_jpg))
#'
#' # Returns an (invisible) data frame with a summary of the process
#' summary
#'
#'
#' # With parameters
#'
#' # Silently returns a data frame
#' resmush_file(tmp_jpg, verbose = TRUE)
#' resmush_file(tmp_jpg, verbose = TRUE, qlty = 10)
#' }
#'
resmush_file <- function(file, suffix = "_resmush", qlty = 92, verbose = FALSE,
                         exif_preserve = FALSE) {
  # Call single
  iter <- seq_len(length(file))
  res_vector <- lapply(iter, function(x) {
    df <- resmush_file_single(
      file[x], suffix,
      qlty, verbose, exif_preserve
    )
    df
  })

  # Bind and output
  df_end <- do.call("rbind", res_vector)

  return(invisible(df_end))
}


# Single call
resmush_file_single <- function(file, suffix = "_resmush", qlty = 92,
                                verbose = FALSE, exif_preserve = FALSE) {
  outfile <- add_suffix(file, suffix)
  # Master table with results
  res <- data.frame(
    src_img = file, dest_img = NA, src_size = NA,
    dest_size = NA, compress_ratio = NA, notes = NA
  )

  # Check access
  # Internal option, for checking purposes only
  test <- getOption("resmush_test_offline", FALSE)
  if (any(isFALSE(curl::has_internet()), test)) {
    cli::cli_alert_warning("Offline")
    res$notes <- "Offline"
    return(invisible(res))
  }
  # Check if file
  if (!file.exists(file)) {
    cli::cli_alert_warning("{.file {file}} not found on disk.")
    res$notes <- "local file does not exists"
    return(invisible(res))
  }

  # Initial call to size in disk
  src_size <- file.size(file)
  src_size <- make_object_size(src_size)
  src_size_pretty <- format(src_size, units = "auto")

  res$src_size <- src_size_pretty

  # API Calls -----
  ## 1. Send local file -----

  # Create file object
  file_post <- httr::upload_file(file)
  file_post$name <- basename(file)

  # Send to reSmusht
  # Make logical
  exif_preserve <- isTRUE(exif_preserve)

  api_post <- httr::POST(
    paste0(
      "http://api.resmush.it/?qlty=", qlty,
      "&exif=", exif_preserve
    ),
    body = list(files = file_post)
  )

  res_post <- httr::content(api_post)

  if ("error" %in% names(res_post)) {
    cli::cli_alert_warning("API Error for {.file {file}}")
    cli::cli_bullets(c("i" = "Error {res_post$error}: {res_post$error_long}"))

    res$notes <- paste0(res_post$error, ": ", res_post$error_long)
    return(invisible(res))
  }

  # nocov start
  if (!"dest" %in% names(res_post)) {
    cli::cli_alert_warning(
      "API Not responding, check {.href https://resmush.it/status}"
    )
    res$notes <- "API Not responding, check https://resmush.it/status}"
    return(invisible(res))
  }
  # nocov end

  ##  2. Download from dest ----
  dwn_opt <- httr::GET(
    res_post$dest,
    httr::write_disk(outfile, overwrite = TRUE)
  )

  # Corner case
  # Internal option, for checking purposes only
  test_corner <- getOption("resmush_test_corner", FALSE)
  if (any(httr::status_code(dwn_opt) != 200, test_corner)) {
    cli::cli_alert_warning(
      "API Not responding, check {.href https://resmush.it/status}"
    )
    res$notes <- "API Not responding, check https://resmush.it/status}"
    return(invisible(res))
  }

  # Finally
  res$dest_img <- outfile

  out_size <- file.size(outfile)
  out_size <- make_object_size(out_size)
  out_size_pretty <- format(out_size, units = "auto")

  res$dest_size <- out_size_pretty
  # Reduction ratio
  red_ratio <- 1 - as.integer(out_size) / as.integer(src_size)
  res$compress_ratio <- sprintf("%0.1f%%", red_ratio * 100)
  res$notes <- "OK ;)"

  if (verbose) {
    cli::cli_alert_success("Optimizing {.file {file}}:")

    cli::cli_bullets(c(
      "i" = "Effective compression ratio: {res$compress_ratio}",
      "i" = "Current size: {res$dest_size} (was {res$src_size})",
      "i" = "Output: {.file {outfile}}"
    ))
  }
  return(invisible(res))
}
