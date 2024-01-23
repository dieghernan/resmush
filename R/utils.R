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
add_suffix <- function(x, suffix = "_resmush") {
  # Handle suffix
  if (any(is.na(suffix), is.null(suffix), suffix == "")) {
    return(x)
  }

  # If not handle suffix
  base_file <- tools::file_path_sans_ext(x)
  ext_file <- tools::file_ext(x)

  newname <- paste0(base_file, suffix, ".", ext_file)
  return(newname)
}

#' Create unique paths to files
#'
#' @param x A path
#'
#' @noRd
make_unique_paths <- function(x) {
  dir_file <- dirname(x)
  base_names <- basename(x)

  res <- character(length = length(base_names))
  iter <- seq_len(length(base_names))


  for (i in iter) {
    this_file <- base_names[i]

    if (!this_file %in% res) {
      res[i] <- this_file
      next
    }
    newname <- tools::file_path_sans_ext(this_file)
    ext <- tools::file_ext(this_file)

    for (j in seq(1, 100)) {
      f <- paste0(newname, "_", sprintf("%002d", j), ".", ext)
      if (!f %in% res) {
        res[i] <- f
        break
      }
    }
  }

  file.path(dir_file, res)
}

# Utils for testing
load_inst_to_temp <- function(file) {
  f <- system.file(paste0("extimg/", file), package = "resmush")
  tmp <- file.path(tempdir(), basename(f))
  if (file.exists(tmp)) unlink(tmp, force = TRUE)
  file.copy(f, tempdir(), overwrite = TRUE)
  tmp
}
