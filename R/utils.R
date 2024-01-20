make_object_size <- function(x) {
  x <- as.integer(x)
  classob <- object.size(x)
  class(x) <- class(classob)
  x
}

# Utils for testing
load_inst_to_temp <- function(file) {
  f <- system.file(paste0("extimg/", file), package = "resmush")
  tmp <- file.path(tempdir(), basename(f))
  if (file.exists(tmp)) unlink(tmp, force = TRUE)
  file.copy(f, tempdir(), overwrite = TRUE)
  tmp
}
