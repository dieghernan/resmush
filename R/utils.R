#' Create an `object_size` object from an integer
#'
#' @param x An integer
#' @noRd
make_object_size <- function(x) {
  x <- as.integer(x)
  classob <- object.size(x)
  class(x) <- class(classob)
  x
}


#' Add suffix to base name
#'
#' @param x A character
#' @param suffix Suffix to be added
#'
#' @noRd
add_suffix <- function(x, suffix = "_resmush", overwrite = FALSE) {
  # Handle suffix
  if (any(
    is.na(suffix), is.null(suffix), suffix == "",
    overwrite
  )) {
    return(x)
  }

  # If not handle suffix
  base_file <- tools::file_path_sans_ext(x)
  ext_file <- tools::file_ext(x)

  newname <- paste0(base_file, suffix, ".", ext_file)
  return(newname)
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

  if (!dir.exists(dest_dir)) dir.create(dest_dir, recursive = TRUE)

  tmp <- file.path(dest_dir, basename(f))


  if (file.exists(tmp)) unlink(tmp, force = TRUE)
  file.copy(f, dest_dir, overwrite = TRUE)
  tmp
}
