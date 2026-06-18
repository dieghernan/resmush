#' Format an integer as an `object_size` object
#'
#' @param x An integer.
#' @noRd
make_pretty_size <- function(x) {
  x <- as.integer(x)
  classob <- object.size(x)
  class(x) <- class(classob)
  pretty_size <- format(x, units = "auto")
  pretty_size
}

#' Create an empty result table
#'
#' @param src Input image path or URL.
#'
#' @noRd
new_resmush_result <- function(src) {
  data.frame(
    src_img = src,
    dest_img = NA,
    src_size = NA,
    dest_size = NA,
    compress_ratio = NA,
    notes = NA,
    src_bytes = NA,
    dest_bytes = NA
  )
}

#' Add size and compression metadata to a result table
#'
#' @param res Result table created by `new_resmush_result()`.
#' @param src_size,dest_size Source and destination sizes in bytes.
#'
#' @noRd
add_size_summary <- function(res, src_size, dest_size) {
  res$src_bytes <- src_size
  res$src_size <- make_pretty_size(src_size)
  res$dest_bytes <- dest_size
  res$dest_size <- make_pretty_size(dest_size)

  reduction_ratio <- 1 - dest_size / src_size
  res$compress_ratio <- sprintf("%0.2f%%", reduction_ratio * 100)
  res$notes <- "OK"

  res
}

#' Process inputs with optional progress reporting
#'
#' @param inputs A character vector of image paths or URLs.
#' @param worker A function called once per input position.
#' @param progress Logical. Should a progress bar be displayed?
#' @param progress_label A label displayed after the progress counter.
#'
#' @noRd
resmush_map <- function(inputs, worker, progress, progress_label) {
  if (progress) {
    opts <- options()
    on.exit(options(
      cli.progress_bar_style = opts$cli.progress_bar_style,
      cli.progress_show_after = opts$cli.progress_show_after,
      cli.spinner = opts$cli.spinner
    ))

    options(
      cli.progress_bar_style = "fillsquares",
      cli.progress_show_after = 0,
      cli.spinner = "clock"
    )

    cli::cli_progress_bar(
      format = paste0(
        "{cli::pb_spin} reSmushing | {cli::pb_bar} ",
        "{cli::pb_percent} [{cli::pb_elapsed}] | ETA: {cli::pb_eta} ",
        "({cli::pb_current}/{cli::pb_total} ",
        progress_label,
        ")"
      ),
      total = length(inputs),
      clear = FALSE
    )
  }

  res_df <- NULL

  for (i in seq_along(inputs)) {
    if (progress) {
      cli::cli_progress_update()
    }

    df <- worker(i)

    if (is.null(df)) {
      next
    }

    if (is.null(res_df)) {
      res_df <- df
    } else {
      res_df <- rbind(res_df, df)
    }
  }

  res_df
}

#' Download an optimized file returned by the API
#'
#' @param url An optimized image URL returned by the API.
#' @param outfile A destination path.
#' @param src The original source used in error messages.
#' @param source_type Either `"file"` or `"url"`.
#'
#' @noRd
download_optimized_file <- function(url, outfile, src, source_type) {
  dwn_opt <- httr2::request(url)
  dwn_opt <- httr2::req_headers(
    dwn_opt,
    referer = "https://dieghernan.github.io/resmush/"
  )

  req_head <- httr2::req_method(dwn_opt, "HEAD")
  req_head <- httr2::req_error(req_head, is_error = function(x) {
    FALSE
  })
  resp_head <- httr2::req_perform(req_head)

  test_no_file <- getOption("resmush_test_no_file", FALSE)
  if (any(httr2::resp_is_error(resp_head), test_no_file)) {
    err_code <- httr2::resp_status(resp_head) # nolint
    err <- httr2::resp_status_desc(resp_head) # nolint

    if (source_type == "file") {
      cli::cli_alert_danger(paste0(
        "Cannot download optimized file: HTTP ",
        "{.val {err_code}} {.emph {err}}.\n{.path {src}}"
      ))
    } else {
      cli::cli_alert_danger(paste0(
        "Cannot download optimized image from URL: HTTP ",
        "{.val {err_code}} {.emph {err}}.\n{.url {src}}"
      ))
    }

    return(NULL)
  }

  httr2::req_perform(dwn_opt, path = outfile)
}

#' Add a suffix before a file extension
#'
#' @param x A character vector.
#' @param suffix A suffix to add.
#' @param overwrite Logical. Should the input paths be returned unchanged?
#'
#' @noRd
add_suffix <- function(x, suffix = "_resmush", overwrite = FALSE) {
  # Return unchanged paths when overwriting or no suffix is requested.
  if (any(is.null(suffix), is.na(suffix), !nzchar(suffix), overwrite)) {
    return(x)
  }

  # Append suffix before file extensions.
  base_file <- tools::file_path_sans_ext(x)
  ext_file <- tools::file_ext(x)

  newname <- paste0(base_file, suffix, ".", ext_file)
  newname
}

#' Create a unique file path to avoid overwriting
#'
#' @param x A file path.
#' @param overwrite Logical. Should an existing file be overwritten?
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

# Utilities for testing.
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

  # Create a random temporary directory name.
  temp_name <- paste0(sample(LETTERS, n, replace = TRUE), collapse = "")

  dest_dir <- file.path(tempdir(), temp_name)

  if (!dir.exists(dest_dir)) {
    dir.create(dest_dir, recursive = TRUE)
  }

  # Copy installed example files.
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
