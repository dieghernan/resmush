#' Clean files created by \CRANpkg{resmush}
#'
#' @description
#' **Use with caution.** Remove files created by [resmush_file()] from one or
#' more directories.
#'
#' @param dir A character vector of directory paths. See the `path` argument of
#'   [list.files()].
#' @param suffix A character string identifying files to remove. The default is
#'   `"_resmush"`, the default suffix used by [resmush_file()].
#' @param recursive Logical. Should the file search recurse into directories?
#'
#' @returns
#' An [invisible()] `NULL`. Messages summarize the files found and removed.
#'
#' @seealso
#' [resmush_file()], [resmush_dir()], [list.files()], [unlink()].
#'
#' @family helpers
#' @export
#' @encoding UTF-8
#' @examplesIf curl::has_internet()
#' \donttest{
#' # Simple example.
#'
#' png_file <- system.file("extimg/example.png", package = "resmush")
#'
#' # Copy to a temporary file with a given suffix.
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
      "No files to clean in {.path {dir}} with suffix {.val {suffix}}."
    )
    return(invisible(NULL))
  }

  cli::cli_alert_info("Removing {.val {length(allfiles)}} file{?s}:")

  make_bull <- allfiles
  names(make_bull) <- rep(">", length(make_bull))
  cli::cli_bullets(make_bull)

  unlink(allfiles, force = TRUE)
  invisible(NULL)
}
