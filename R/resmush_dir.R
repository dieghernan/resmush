#' Optimize local files in directories
#'
#' @description
#' Optimize all local files in a directory (or list of directories) using the
#' [reSmush.it API](https://resmush.it/).
#'
#' @param dir A character vector of paths to local directories.
#' @param ext A [`regex`][base::regex] indicating the extensions of the files
#'   to optimize. The default value captures all extensions supported by the
#'   API.
#' @param suffix Character. Defaults to `"_resmush"`. By default, a new file
#'   with the suffix is created in the same directory (i.e.,
#'   optimized `example.png` becomes `example_resmush.png`). Values `""`, `NA`
#'   and `NULL` are equivalent to `overwrite = TRUE`.
#' @param overwrite Logical. Should the files in `dir` be overwritten? If `TRUE`
#'   `suffix` is ignored.
#' @param recursive Logical. Should file search within `dir` be recursive? See
#'   also [list.files()].
#' @inheritParams resmush_file
#' @inheritDotParams resmush_file qlty exif_preserve
#'
#' @return
#' Writes optimized files to disk in the directories specified in `dir` if the
#' API call is successful.
#'
#' In all cases, an [invisible()] data frame summarizing the process is returned
#' as well.
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
#' # Return the same information in the invisible data frame.
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
    cli::cli_alert_info("No files found in {.path {dir}} with ext {.val {ext}}")
    return(invisible(NULL))
  }
  if (report) {
    # nolint start
    nf <- length(allfiles)
    # nolint end
    cli::cli_alert_info("Resmushing {nf} file{?s}")
  }

  # Call `resmush_file()`.
  resmush_file(
    allfiles,
    suffix = suffix,
    overwrite = overwrite,
    progress = progress,
    report = report,
    ...
  )
}
