#' Optimize a local file
#'
#' @description
#' Optimize local images using the [reSmush.it API](https://resmush.it/).
#'
#' **Note that** the default parameters of the function `outfile = file`
#' **overwrites** the local file. See **Examples**.
#'
#' @param file Path or paths to a local file. **reSmush** can optimize the
#'  following image files:
#'  * `png`
#'  * `jpg`
#'  * `gif`
#'  * `bmp`
#'  * `tif`
#' @param outfile Path or paths where the optimized file would be store in
#'   your disk. By default, it would override the file specified in `file`. It
#'   should be of the same length than `file` parameter.
#' @param qlty Only affects `jpg` files. Integer between 0 and 100 indicating
#' the optimization level. For optimal results use vales above 90.
#' @param verbose Logical. If `TRUE` displays a summary of the results.
#' @param exif_preserve Logical. Should be the
#'   [Exif](https://en.wikipedia.org/wiki/Exif) information removed as well?
#'   Default is to remove (i.e. `exif_preserve = FALSE`).
#' @return
#' Writes on disk the optimized file if the API call is successful.
#' In any case, a (invisibly) data frame with a summary of the process is
#' returned as well.
#'
#' @seealso
#' [reSmush.it API](https://resmush.it/api) docs.
#'
#' [resmush_url()]
#' @export
#'
#' @examplesIf curl::has_internet()
#'
#' \donttest{
#' png_file <- system.file("extimg/example.png", package = "resmush")
#'
#' # For the example, write to a temp file
#' tmp_png <- tempfile(fileext = ".png")
#'
#' resmush_file(png_file, outfile = tmp_png)
#'
#' # Several paths
#' jpg_file <- system.file("extimg/example.jpg", package = "resmush")
#' tmp_jpg <- tempfile(fileext = ".jpg")
#'
#'
#' summary <- resmush_file(c(png_file, jpg_file), outfile = c(
#'   tmp_png,
#'   tmp_jpg
#' ))
#'
#' # Returns an (invisible) data frame with a summary of the process
#' summary
#'
#'
#' # With parameters
#'
#' # Silently returns a data frame
#' resmush_file(jpg_file, outfile = tmp_jpg, verbose = TRUE)
#' resmush_file(jpg_file, outfile = tmp_jpg, verbose = TRUE, qlty = 10)
#' }
#'
resmush_file <- function(file, outfile = file, qlty = 92, verbose = FALSE,
                         exif_preserve = FALSE) {
  # High level function for vectors

  # Check lengths
  l1 <- length(file)
  l2 <- length(outfile)

  if (l1 != l2) {
    cli::cli_abort(
      paste0(
        "Lengths of {.arg file} and {.arg outfile}",
        "should be the same ",
        "({l1} vs. {l2})"
      )
    )
  }


  # Once checked call single
  iter <- seq_len(l1)

  res_vector <- lapply(iter, function(x) {
    df <- resmush_file_single(
      file[x], outfile[x],
      qlty, verbose, exif_preserve
    )
    df
  })

  # Bind and output
  df_end <- do.call("rbind", res_vector)

  return(invisible(df_end))
}


# Single call
resmush_file_single <- function(file, outfile = file, qlty = 92,
                                verbose = FALSE, exif_preserve = FALSE) {
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
