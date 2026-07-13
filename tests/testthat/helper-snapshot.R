scrub_snapshot_paths <- function(x) {
  x <- gsub("\\", "/", x, fixed = TRUE)

  for (temp_path in snapshot_temp_paths()) {
    x <- gsub(path_regex(temp_path), "<tempdir>", x, perl = TRUE)
  }

  x <- x[!grepl("reSmushing", x, fixed = TRUE)]
  x <- x[nzchar(x)]
  x <- gsub(
    "<tempdir>(/working_dir/Rtmp[^/]+)?/[A-Z]{4}/[A-Z]{4}_[0-9]+",
    "<tempdir>/<random-dir>",
    x
  )
  x <- gsub("(resmush-(dir|file)-)[[:xdigit:]]+", "\\1<id>", x)
  x <- gsub("(test_dir_(nomess|onefile|twofile))[[:xdigit:]]+", "\\1<id>", x)
  x <- gsub("(test2|resmush_test)[[:xdigit:]]+", "\\1<id>", x)
  x <- gsub("(file|exif)[[:xdigit:]]+", "\\1<id>", x)

  x
}

snapshot_temp_paths <- function() {
  paths <- c(
    tempdir(),
    normalizePath(tempdir(), winslash = "/", mustWork = FALSE),
    Sys.getenv(c("TMPDIR", "TEMP", "TMP"), unset = NA)
  )

  paths <- paths[!is.na(paths) & nzchar(paths)]
  paths <- unique(c(
    paths,
    normalizePath(paths, winslash = "/", mustWork = FALSE)
  ))
  paths <- gsub("\\", "/", paths, fixed = TRUE)
  paths <- gsub("/+$", "", paths)
  paths <- unique(c(paths, macos_private_var_variants(paths)))
  paths <- paths[!is.na(paths) & nzchar(paths)]
  paths[order(nchar(paths), decreasing = TRUE)]
}

macos_private_var_variants <- function(paths) {
  private_paths <- ifelse(
    startsWith(paths, "/private/var/"),
    sub("^/private", "", paths),
    NA_character_
  )
  public_paths <- ifelse(
    startsWith(paths, "/var/"),
    paste0("/private", paths),
    NA_character_
  )

  c(private_paths, public_paths)
}

path_regex <- function(path) {
  pieces <- strsplit(path, "/", fixed = TRUE)[[1]]
  pieces <- gsub("([][{}()+*^$|\\\\?.])", "\\\\\\1", pieces)
  paste(pieces, collapse = "/+")
}
