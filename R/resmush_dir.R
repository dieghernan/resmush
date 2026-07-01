#' Optimize image files in directories
#'
#' @description
#' Optimize supported image files in one or more directories with the
#' [reSmush.it API](https://resmush.it/api/). The API is free for personal use
#' and accepts files smaller than 5 MB.
#'
#' @param dir A character vector of paths to local directories.
#' @param ext A [`regex`][base::regex] matching file extensions to optimize. The
#'   default matches lowercase `.png`, `.jpg`, `.jpeg`, `.gif`, `.bmp` and
#'   `.tif` extensions.
#' @param suffix A character string inserted before each output file extension.
#'   The default is `"_resmush"`. Therefore, `example.png` becomes
#'   `example_resmush.png`. Values `""`, `NA` and `NULL` are equivalent to
#'   `overwrite = TRUE`.
#' @param overwrite Logical. Should the input files be overwritten? If `TRUE`,
#'   `suffix` is ignored.
#' @param recursive Logical. Should the file search within `dir` be recursive?
#'   See [list.files()].
#' @inheritParams resmush_file
#' @inheritDotParams resmush_file qlty exif_preserve
#'
#' @returns
#' An invisibly returned data frame with one row per result and columns
#' containing source and destination paths, formatted and raw file sizes,
#' compression ratios and status notes. Returns `NULL` if no result is
#' available. Successful API calls also write the optimized files to disk.
#'
#' @seealso
#' - [resmush_clean_dir()] removes output files created by previous runs.
#' - The [reSmush.it API documentation](https://resmush.it/api/) describes the
#'   external service.
#'
#' @family optimize
#' @export
#' @encoding UTF-8
#' @examplesIf httr2::is_online()
#' \donttest{
#' # Copy the example directory.
#' example_dir <- system.file("extimg", package = "resmush")
#' temp_dir <- tempdir()
#' file.copy(example_dir, temp_dir, recursive = TRUE)
#'
#' # Create the destination folder path.
#' dest_folder <- file.path(tempdir(), "extimg")
#'
#' # Optimize files non-recursively.
#' resmush_dir(dest_folder)
#' resmush_clean_dir(dest_folder)
#'
#' # Optimize files recursively.
#' summary <- resmush_dir(dest_folder, recursive = TRUE)
#'
#' # Inspect the returned optimization summary.
#' summary[, -c(1, 2)]
#'
#' # Display the PNG output.
#' if (require("png", quietly = TRUE)) {
#'   a_png <- grepl("png$", summary$dest_img)
#'   my_png <- png::readPNG(summary[a_png, ]$dest_img[2])
#'   grid::grid.raster(my_png)
#' }
#'
#' # Clean up the example files.
#' unlink(dest_folder, force = TRUE, recursive = TRUE)
#' }
resmush_dir <- function(
  dir,
  ext = "\\.(png|jpe?g|bmp|gif|tif)$",
  suffix = "_resmush",
  overwrite = FALSE,
  progress = TRUE,
  report = TRUE,
  recursive = FALSE,
  ...
) {
  allfiles <- list.files(
    path = dir,
    pattern = ext,
    recursive = recursive,
    full.names = TRUE
  )

  if (length(allfiles) < 1) {
    cli::cli_alert_info(
      "No files matching {.val {ext}} found in {.path {dir}}."
    )
    return(invisible(NULL))
  }
  if (report) {
    # nolint start
    nf <- length(allfiles)
    # nolint end
    cli::cli_alert_info("Optimizing {.val {nf}} file{?s}.")
  }

  resmush_file(
    allfiles,
    suffix = suffix,
    overwrite = overwrite,
    progress = progress,
    report = report,
    ...
  )
}
