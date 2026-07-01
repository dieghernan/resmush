#' Remove output files from directories
#'
#' @description
#' **Use with caution.** Remove files that match `suffix` from one or more
#' directories. This is intended to clean output files created by
#' [resmush_file()] or [resmush_dir()].
#'
#' @param dir A character vector of directory paths. See the `path` argument of
#'   [list.files()].
#' @param suffix A character string containing the suffix pattern used to
#'   identify files. The value is interpreted as a regular expression. The
#'   default is `"_resmush"`, the default suffix used by [resmush_file()].
#' @param recursive Logical. Should the file search recurse into directories?
#'
#' @returns
#' An [invisible()] `NULL`. Messages list the files selected for removal.
#'
#' @seealso [resmush_file()] and [resmush_dir()] create the suffixed output
#'   files that this function removes.
#'
#' @family helpers
#' @export
#' @encoding UTF-8
#' @examples
#' \donttest{
#' # Create a temporary file with a suffix to remove.
#' png_file <- system.file("extimg/example.png", package = "resmush")
#' suffix <- "_would_be_removed"
#' tmp_png <- file.path(
#'   tempdir(),
#'   paste0("example", suffix, ".png")
#' )
#'
#' file.exists(tmp_png)
#' file.copy(png_file, tmp_png, overwrite = TRUE)
#'
#' file.exists(tmp_png)
#'
#' # Run with the default suffix. This should not remove the file.
#' resmush_clean_dir(tempdir())
#'
#' file.exists(tmp_png)
#'
#' # Use the matching suffix to remove the file.
#' resmush_clean_dir(tempdir(), suffix = suffix)
#'
#' file.exists(tmp_png)
#' }
resmush_clean_dir <- function(dir, suffix = "_resmush", recursive = FALSE) {
  allfiles <- list.files(
    pattern = paste0(suffix, "\\."),
    path = dir,
    full.names = TRUE,
    recursive = recursive
  )

  if (length(allfiles) < 1) {
    cli::cli_alert_info(
      "No files with suffix {.val {suffix}} found in {.path {dir}}."
    )
    return(invisible(NULL))
  }

  cli::cli_alert_info("Removing {.val {length(allfiles)}} file{?s}:")

  make_bull <- vapply(
    allfiles,
    function(path) cli::format_inline("{.path {path}}"),
    character(1)
  )
  names(make_bull) <- rep(">", length(make_bull))
  cli::cli_bullets(make_bull)

  unlink(allfiles, force = TRUE)
  invisible(NULL)
}
