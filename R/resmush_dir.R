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
#'   The default is `"_resmush"`, so `example.png` becomes
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
#' A data frame with source and destination paths, file sizes, compression
#' ratios and status notes, returned invisibly. Successful API calls also write
#' the optimized files to disk.
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
#' \donttest{
#' # Copy the example directory.
#' example_dir <- system.file("extimg", package = "resmush")
#' temp_dir <- tempdir()
#' file.copy(example_dir, temp_dir, recursive = TRUE)
#'
#' # Create the destination folder path.
#' dest_folder <- file.path(tempdir(), "extimg")
#'
#' # Non-recursive.
#' resmush_dir(dest_folder)
#' resmush_clean_dir(dest_folder)
#'
#' # Recursive.
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
      "No files found in {.path {dir}} matching extension pattern {.val {ext}}."
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
