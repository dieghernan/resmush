#' Optimize files of several directories
#'
#' @description
#' Optimize all the local files of a directory (or list of directories) using
#' the  [reSmush.it API](https://resmush.it/).
#'
#' @param dir Character or vector of characters representing paths of local
#'   directories.
#' @param ext [`regex`][base::regex] indicating the extensions of the files to
#'   be optimized. The default value would capture all the extensions admitted
#'   by the API.
#' @param suffix Character, defaults to `"_resmush"`. By default, a new file
#'   with the suffix is created in the same directory (i.e.,
#'   optimized `example.png` would be `example_resmush.png`). Values `""`, `NA`
#'   and `NULL` would be the same as `overwrite = TRUE`.
#' @param overwrite Logical. Should the files in `dir` be overwritten? If `TRUE`
#'   `suffix` would be ignored.
#' @param recursive Logical. Should the `dir` file search be recursive? See also
#'   [list.files()].
#' @inheritParams resmush_file
#' @inheritDotParams resmush_file qlty exif_preserve
#'
#' @return
#' Writes on disk the optimized file if the API call is successful in the
#' directories specified in `dir`.
#'
#' In all cases, an ([invisible()]) data frame with a summary of the process is
#' returned as well.
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
#' # Get example dir and copy
#' example_dir <- system.file("extimg", package = "resmush")
#' temp_dir <- tempdir()
#' file.copy(example_dir, temp_dir, recursive = TRUE)
#'
#' # Dest folder
#'
#' dest_folder <- file.path(tempdir(), "extimg")
#'
#' # Non-recursive
#' resmush_dir(dest_folder)
#' resmush_clean_dir(dest_folder)
#'
#' # Recursive
#' summary <- resmush_dir(dest_folder, recursive = TRUE)
#'
#' # Same info in the invisible df
#' summary[, -c(1, 2)]
#'
#' # Display with png
#' if (require("png", quietly = TRUE)) {
#'   a_png <- grepl("png$", summary$dest_img)
#'   my_png <- png::readPNG(summary[a_png, ]$dest_img[2])
#'   grid::grid.raster(my_png)
#' }
#'
#' # Clean up example
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
      "No files found in {.path {dir}} with ext {.val {ext}}"
    )
    return(invisible(NULL))
  }
  if (report) {
    # nolint start
    nf <- length(allfiles)
    # nolint end
    cli::cli_alert_info("Resmushing {nf} file{?s}")
  }

  # Call resmush_file

  resmush_file(
    allfiles,
    suffix = suffix,
    overwrite = overwrite,
    progress = progress,
    report = report,
    ...
  )
}
