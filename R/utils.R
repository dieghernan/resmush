make_object_size <- function(x) {
  x <- as.integer(x)
  classob <- object.size(x)
  class(x) <- class(classob)
  x
}

# Handle names
make_unique_paths <- function(x, res) {
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
    newname <- name_sans_ext(this_file)
    ext <- my_file_ext(this_file)

    for (j in seq(1, 100)) {
      f <- paste0(newname, "_", j, ext)
      if (!f %in% res) {
        res[i] <- f
        break
      }
    }
  }

  file.path(dir_file, res)
}

name_sans_ext <- function(x) {
  sans_ext <- vapply(x, FUN = function(y) {
    name_parts <- unlist(strsplit(y, ".", fixed = TRUE))

    paste0(name_parts[-length(name_parts)], collapse = ".")
  }, FUN.VALUE = character(1))

  unname(sans_ext)
}



my_file_ext <- function(x) {
  ext_only <- vapply(x, FUN = function(y) {
    name_parts <- unlist(strsplit(y, ".", fixed = TRUE))

    paste0(".", name_parts[length(name_parts)])
  }, FUN.VALUE = character(1))

  unname(ext_only)
}



# Utils for testing
load_inst_to_temp <- function(file) {
  f <- system.file(paste0("extimg/", file), package = "resmush")
  tmp <- file.path(tempdir(), basename(f))
  if (file.exists(tmp)) unlink(tmp, force = TRUE)
  file.copy(f, tempdir(), overwrite = TRUE)
  tmp
}
