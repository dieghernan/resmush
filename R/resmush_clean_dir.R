resmush_clean_dir <- function(dir, suffix = "_resmush", recursive = FALSE) {
  allfiles <- list.files(
    pattern = paste0(suffix, "\\."),
    path = dir, full.names = TRUE,
    recursive = recursive
  )

  res_un <- unlink(allfiles, force = TRUE)
  return(invisible(res_un))
}
