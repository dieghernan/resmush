#' Optimize files of several directories
#'
#' @description
#' Optimize all the local files of a directory (or list of directories) using
#' the  [reSmush.it API](https://resmush.it/).
#'
#' @param dir Character or vector of characters representing paths of local
#'   directories.
#' @param ext [regex] indicating the extensions of the files to be optimized.
#'   The default value would capture all the extensions admitted by the API.
#' @param suffix Character, defaults to `"_resmush"`. By default, a new file
#'   with the suffix is created in the same directory (i.e.,
#'   optimized `example.png` would be `example_resmush.png`). Use `""`, `NA`
#'   of `NULL` for overwrite the files.
#' @inheritParams resmush_file
#' @inheritDotParams resmush_file qlty exif_preserve
#'
#' @return
#' Writes on disk the optimized file if the API call is successful in the
#' directories specified in `dir`.
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
#' \donttest{
#' # Get example files and copy to a temporary dir
#' example_files <- list.files(system.file(package = "resmush"),
#'   pattern = "\\.(png|jpe?g)$",
#'   recursive = TRUE,
#'   full.names = TRUE
#' )
#'
#' temp_dir <- file.path(tempdir(), "example_dir")
#' if (!dir.exists(temp_dir)) dir.create(temp_dir)
#' file.copy(example_files, temp_dir)
#'
#' resmush_dir(temp_dir, verbose = TRUE)
#'
#' # Clean up
#' unlink(temp_dir, force = TRUE)
#' }
#'
resmush_dir <- function(dir, ext = "\\.(png|jpe?g|bmp|gif|tif|webp)$",
                        suffix = "_resmush", verbose = FALSE, ...) {
  allfiles <- list.files(
    path = dir, pattern = ext, recursive = FALSE,
    full.names = TRUE
  )

  # Call resmush_file

  resmush_file(allfiles, suffix = suffix, verbose = verbose, ...)
}
