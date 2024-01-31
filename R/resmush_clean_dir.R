#' Helper function for cleaning files created by **resmush**
#'
#' @description
#'
#'
#' **Use with caution**. This would remove files from your computer.
#'
#' Clean a directory (or a list of directories) of files created by
#' [resmush_file()].
#'
#' @param dir A character vector of full path names. See [list.files()], `path`
#'   argument.
#' @param suffix  Character, defaults to `"_resmush"`. See [resmush_file()].
#'
#' @param recursive Logical. Should the files to be deleted recurse into
#'   directories?
#'
#' @return
#'
#' Nothing. Produce messages with information of the process.
#'
#' @seealso
#' [resmush_file()], [resmush_dir()], [list.files()], [unlink()]
#' @family helpers
#'
#' @export
#' @keywords internal
#' @examplesIf curl::has_internet()
#' \donttest{
#' # Simple example
#'
#' png_file <- system.file("extimg/example.png", package = "resmush")
#'
#'
#' # Copy to a temporary file with a given suffix
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
#' # This won't remove it
#' resmush_clean_dir(tempdir())
#'
#' file.exists(tmp_png)
#'
#' # Need suffix
#' resmush_clean_dir(tempdir(), suffix = suffix)
#'
#' file.exists(tmp_png)
#' }
resmush_clean_dir <- function(dir, suffix = "_resmush", recursive = FALSE) {
  allfiles <- list.files(
    pattern = paste0(suffix, "\\."),
    path = dir, full.names = TRUE,
    recursive = recursive
  )

  if (length(allfiles) < 1) {
    cli::cli_alert_info(
      "No files to clean in {.path {dir}} with suffix {.val {suffix}\\.}."
    )
    return(invisible(NULL))
  }

  cli::cli_alert_info("Would remove {length(allfiles)} file{?s}:")

  make_bull <- allfiles
  names(make_bull) <- rep(">", length(make_bull))
  cli::cli_bullets(make_bull)

  unlink(allfiles, force = TRUE)
  return(invisible(NULL))
}
