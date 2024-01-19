make_object_size <- function(x) {
  x <- as.integer(x)
  classob <- object.size(x)
  class(x) <- class(classob)
  x
}
