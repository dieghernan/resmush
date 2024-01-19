#' Optimize a local file
#'
#' @description
#' Optimize a local images using the [reSmush.it API](https://resmush.it/).
#'
#' **Note that** the default parameters of the function `outfile = file`
#' **overwrites** the local file. See **Examples**.
#'
#' @param file Path to a local file. **reSmush** can optimize the
#'  following image files:
#'  * `png`
#'  * `jpg`
#'  * `gif`
#'  * `bmp`
#'  * `tif`
#' @param outfile Path where the optimized file would be store in your disk.
#'   By default, it would override the file specified in `file`.
#' @param qlty Only affects `jpg` files. Integer between 0 and 100 indicating
#' the optimization level. For optimal results use vales above 90.
#' @param verbose Logical. If `TRUE` displays a summary of the results.
#'
#' @return
#' Writes on disk the optimized file if the API call is successful.
#' In any case, a (invisibly) data frame with a summary of the process is
#' returned as well.
#'
#' @seealso
#' [reSmush.it API](https://resmush.it/api) docs.
#'
#' @export
#'
#' @examplesIf curl::has_internet()
#'
#' \donttest{
#' png_file <- system.file("extimg/example.png", package = "resmush")
#'
#' # For example, writes to a temp file
#' tmp_png <- tempfile(fileext = ".png")
#'
#' # Silently returns a data frame
#' png_res <- resmush_file(png_file, outfile = tmp_png)
#' png_res[, -c(1:2)]
#'
#' # Use with jpg and parameters
#' jpg_file <- system.file("extimg/example.jpg", package = "resmush")
#'
#' # For example, writes to a temp file
#' tmp_jpg <- tempfile(fileext = ".jpg")
#'
#' # Silently returns a data frame
#' resmush_file(jpg_file, outfile = tmp_png, verbose = TRUE)
#' resmush_file(jpg_file, outfile = tmp_png, verbose = TRUE, qlty = 10)
#' }
resmush_file <- function(file, outfile = file, qlty = 92, verbose = FALSE) {
  # Master table with results
  res <- data.frame(
    src_img = file, dest_img = NA, src_size = NA,
    dest_size = NA, compress_ratio = NA, notes = NA
  )

  # Check access
  if (!curl::has_internet()) {
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
  api_post <- httr::POST(
    paste0("http://api.resmush.it/?qlty=", qlty),
    body = list(files = file_post)
  )

  res_post <- httr::content(api_post)

  if ("error" %in% names(res_post)) {
    cli::cli_alert_warning("API Error for {.file {file}}")
    cli::cli_bullets(c("i" = "Error {res_post$error}: {res_post$error_long}"))

    res$notes <- paste0(res_post$error, ": ", res_post$error_long)
    return(invisible(res))
  }

  if (!"dest" %in% names(res_post)) {
    cli::cli_alert_warning(
      "API Not responding, check {.href https://resmush.it/status}"
    )
    res$notes <- "API Not responding, check https://resmush.it/status}"
    return(invisible(res))
  }

  ##  2. Download from dest ----
  dwn_opt <- httr::GET(
    res_post$dest,
    httr::write_disk(outfile, overwrite = TRUE)
  )

  if (httr::status_code(dwn_opt) != 200) {
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
  red_ratio <- as.integer(out_size) / as.integer(src_size)
  res$compress_ratio <- sprintf("%0.1f%%", red_ratio * 100)
  res$notes <- "OK ;)"

  if (verbose) {
    cli::cli_alert_success(paste0(
      "{.file {file}} optimized: {res$src_size}",
      " => {res$dest_size} ({res$compress_ratio})"
    ))
  }
  return(invisible(res))
}
