#' Create a pretty `object_size` object from an integer
#'
#' @param x An integer
#' @noRd
make_pretty_size <- function(x) {
  x <- as.integer(x)
  classob <- object.size(x)
  class(x) <- class(classob)
  pretty_size <- format(x, units = "auto")
  pretty_size
}


#' Add suffix to base name
#'
#' @param x A character
#' @param suffix Suffix to be added
#'
#' @noRd
add_suffix <- function(x, suffix = "_resmush", overwrite = FALSE) {
  # Handle suffix
  if (
    any(
      is.null(suffix),
      is.na(suffix),
      suffix == "",
      overwrite
    )
  ) {
    return(x)
  }

  # If not handle suffix
  base_file <- tools::file_path_sans_ext(x)
  ext_file <- tools::file_ext(x)

  newname <- paste0(base_file, suffix, ".", ext_file)
  newname
}

#' Create unique paths to files to avoid overriding
#'
#' @param x A path
#'
#' @noRd
make_unique_paths <- function(x, overwrite) {
  if (overwrite) {
    return(x)
  }

  init_name <- x

  if (!file.exists(init_name)) {
    new_name <- init_name
  } else {
    for (i in seq_len(200)) {
      new_name <- add_suffix(init_name, sprintf("_%002d", i))

      if (!file.exists(new_name)) break
    }
  }

  new_name
}

# Utils for testing
load_inst_to_temp <- function(file, subdir = NULL) {
  f <- system.file(paste0("extimg/", file), package = "resmush")
  if (!is.null(subdir)) {
    dest_dir <- file.path(tempdir(), subdir)
  } else {
    dest_dir <- tempdir()
  }

  if (!dir.exists(dest_dir)) {
    dir.create(dest_dir, recursive = TRUE)
  }

  tmp <- file.path(dest_dir, basename(f))

  file.copy(f, dest_dir, overwrite = TRUE)
  tmp
}

load_dir_to_temp <- function(n = 4) {
  inst_dir <- system.file("extimg", package = "resmush")

  # random name
  temp_name <- paste0(sample(LETTERS, n, replace = TRUE), collapse = "")

  dest_dir <- file.path(tempdir(), temp_name)

  if (!dir.exists(dest_dir)) {
    dir.create(dest_dir, recursive = TRUE)
  }

  # Copy files
  lf <- list.files(inst_dir, full.names = TRUE)
  file.copy(lf, dest_dir, recursive = TRUE)

  dest_dir
}

download_to_temp <- function(url) {
  url <- URLencode(url)
  extt <- tools::file_ext(url)
  tmpfi <- tempfile(fileext = paste0(".", extt))
  rq <- httr2::request(url)
  rq <- httr2::req_headers(
    rq,
    referer = "https://dieghernan.github.io/resmush/"
  )

  dwn <- httr2::req_perform(rq, path = tmpfi) # nolint
  tmpfi
}
