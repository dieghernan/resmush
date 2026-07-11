scrub_snapshot_paths <- function(x) {
  temp_path <- normalizePath(tempdir(), winslash = "/", mustWork = FALSE)
  temp_path_backslash <- chartr("/", "\\", temp_path)

  x <- gsub(temp_path, "<tempdir>", x, fixed = TRUE)
  x <- gsub(temp_path_backslash, "<tempdir>", x, fixed = TRUE)
  x <- gsub("\\", "/", x, fixed = TRUE)
  x <- x[!grepl("reSmushing", x, fixed = TRUE)]
  x <- x[nzchar(x)]
  x <- gsub("<tempdir>/[A-Z]{4}/[A-Z]{4}_[0-9]+", "<tempdir>/<random-dir>", x)
  x <- gsub("(resmush-(dir|file)-)[[:xdigit:]]+", "\\1<id>", x)
  x <- gsub("(test_dir_(nomess|onefile|twofile))[[:xdigit:]]+", "\\1<id>", x)
  x <- gsub("(test2|resmush_test)[[:xdigit:]]+", "\\1<id>", x)
  x <- gsub("(file|exif)[[:xdigit:]]+", "\\1<id>", x)

  x
}
