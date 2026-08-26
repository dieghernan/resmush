local_inst_file <- function(file, subdir = NULL) {
  test_env <- parent.frame()
  inst_file <- system.file(paste0("extimg/", file), package = "resmush")
  dest_dir <- withr::local_tempdir(
    pattern = "resmush-file-",
    .local_envir = test_env
  )

  if (!is.null(subdir)) {
    dest_dir <- file.path(dest_dir, subdir)
    dir.create(dest_dir, recursive = TRUE)
  }

  copied <- file.copy(inst_file, dest_dir, overwrite = TRUE)
  if (!isTRUE(copied)) {
    stop("Could not copy the installed test file.", call. = FALSE)
  }
  file.path(dest_dir, basename(inst_file))
}

local_inst_dir <- function() {
  test_env <- parent.frame()
  inst_dir <- system.file("extimg", package = "resmush")
  dest_dir <- withr::local_tempdir(
    pattern = "resmush-dir-",
    .local_envir = test_env
  )

  files <- list.files(inst_dir, full.names = TRUE)
  copied <- file.copy(files, dest_dir, recursive = TRUE)
  if (!all(copied)) {
    stop("Could not copy the installed test directory.", call. = FALSE)
  }

  dest_dir
}

local_download <- function(url) {
  test_env <- parent.frame()
  url <- URLencode(url)
  ext <- tools::file_ext(url)
  path <- withr::local_tempfile(
    fileext = paste0(".", ext),
    .local_envir = test_env
  )
  req <- httr2::request(url)
  req <- httr2::req_headers(
    req,
    referer = "https://dieghernan.github.io/resmush/"
  )

  resmush_req_perform(req, path = path)
  path
}
