#' Optimize an online file
#'
#' @description
#' Optimize and download an online image using the
#' [reSmush.it API](https://resmush.it/).
#'
#' @param url url to a hosted file. **reSmush** can optimize the
#'  following image files:
#'  * `png`
#'  * `jpg`
#'  * `gif`
#'  * `bmp`
#'  * `tif`
#' @param outfile Path where the optimized file would be store in your disk. By
#' default, a temporary file (see [tempfile()]) with the same [basename()] than
#' the file provided in url would be created.
#' @inheritParams resmush_file
#'
#' @return
#' Writes on disk the optimized file if the API call is successful.
#' In any case, a (invisibly) data frame with a summary of the process is
#' returned as well.
#'
#' @seealso
#' [reSmush.it API](https://resmush.it/api) docs.
#'
#' [resmush_file()]
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
#'
#' # Silently returns a data frame
#' png_res <- resmush_url(png_url)
#' png_res
#'
#' # Use with jpg and parameters
#' jpg_url <- paste0(base_url, "/extimg/example.jpg")
#'
#' # Silently returns a data frame
#' resmush_url(jpg_url, verbose = TRUE)
#' resmush_url(jpg_url, verbose = TRUE, qlty = 10)
#' }
resmush_url <- function(url, outfile = file.path(tempdir(), basename(url)),
                        qlty = 92, verbose = FALSE, exif_preserve = FALSE) {
  # Master table with results
  res <- data.frame(
    src_img = url, dest_img = NA, src_size = NA,
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

  # API Calls -----

  res_get <- smush_from_url(url, qlty, exif_preserve, n_rep = 3)

  if ("error" %in% names(res_get)) {
    cli::cli_alert_warning("API Error for {.href {url}}")
    cli::cli_bullets(c("i" = "Error {res_get$error}: {res_get$error_long}"))

    res$notes <- paste0(res_get$error, ": ", res_get$error_long)
    return(invisible(res))
  }

  # nocov start
  if (!"dest" %in% names(res_get)) {
    cli::cli_alert_warning(
      "API Not responding, check {.href https://resmush.it/status}"
    )
    res$notes <- "API Not responding, check https://resmush.it/status}"
    return(invisible(res))
  }
  # nocov end

  ##  2. Download from dest ----
  dwn_opt <- httr::GET(
    res_get$dest,
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

  src_size <- res_get$src_size
  src_size <- make_object_size(src_size)
  src_size_pretty <- format(src_size, units = "auto")

  res$src_size <- src_size_pretty


  out_size <- file.size(outfile)
  out_size <- make_object_size(out_size)
  out_size_pretty <- format(out_size, units = "auto")

  res$dest_size <- out_size_pretty
  # Reduction ratio
  red_ratio <- 1 - as.integer(out_size) / as.integer(src_size)
  res$compress_ratio <- sprintf("%0.1f%%", red_ratio * 100)
  res$notes <- "OK ;)"

  if (verbose) {
    cli::cli_alert_success("Optimizing {.httr {url}}:")

    cli::cli_bullets(c(
      "i" = "Effective compression ratio: {res$compress_ratio}",
      "i" = "Current size: {res$dest_size} (was {res$src_size})",
      "i" = "Output: {.file {outfile}}"
    ))
  }
  return(invisible(res))
}


# Helper function for retrying the call
# Useful for some cases e.g imgur
smush_from_url <- function(url, qlty, exif_preserve = TRUE, n_rep = 3) {
  # Make logical
  exif_preserve <- isTRUE(exif_preserve)

  for (i in seq(1, n_rep)) {
    api_get <- httr::GET(
      paste0(
        "http://api.resmush.it/ws.php?qlty=", qlty,
        "&img=", url,
        "&exif=", exif_preserve
      )
    )

    res_get <- httr::content(api_get)

    if (!"error" %in% names(res_get)) break
    Sys.sleep(0.5)
  }
  return(res_get)
}
