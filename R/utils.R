#' Check whether an internet connection is available
#'
#' Checks whether an internet connection is available.
#'
#' @returns A logical value.
#'
#' @noRd
resmush_is_online <- function() {
  httr2::is_online()
}

#' Format an integer as an `object_size` object
#'
#' Assigns the `object_size` class to an integer and formats it using
#' automatically selected units.
#'
#' @param x An integer.
#'
#' @returns A formatted character string.
#'
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
#' Creates a one-row result table initialized with missing values.
#'
#' @param src Input image path or URL.
#'
#' @returns A data frame with one row.
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
#' Adds formatted and raw file sizes, the compression ratio and a success note.
#'
#' @param res Result table created by `new_resmush_result()`.
#' @param src_size,dest_size Source and destination sizes in bytes.
#'
#' @returns The updated result data frame.
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
#' Applies a worker function to each input and combines non-`NULL` results.
#'
#' @param inputs A character vector of image paths or URLs.
#' @param worker A function called once per input position.
#' @param progress Logical. Should a progress bar be displayed?
#' @param progress_label A label displayed after the progress counter.
#'
#' @returns A data frame or `NULL` if every worker result is `NULL`.
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
#' Checks the remote file with a `HEAD` request before downloading it.
#'
#' @param url An optimized image URL returned by the API.
#' @param outfile A destination path.
#' @param src The original source used in error messages.
#' @param source_type Either `"file"` or `"url"`.
#'
#' @returns An HTTP response object or `NULL` if the remote file is
#'   unavailable.
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

  if (httr2::resp_is_error(resp_head)) {
    err_code <- httr2::resp_status(resp_head) # nolint
    err <- httr2::resp_status_desc(resp_head) # nolint

    if (source_type == "file") {
      cli::cli_alert_danger(paste0(
        "Cannot download optimized file {.path {src}}. HTTP status: ",
        "{.val {err_code}} ({.emph {err}})."
      ))
    } else {
      cli::cli_alert_danger(paste0(
        "Cannot download optimized image {.url {src}}. HTTP status: ",
        "{.val {err_code}} ({.emph {err}})."
      ))
    }

    return(NULL)
  }

  httr2::req_perform(dwn_opt, path = outfile)
}

#' Add a suffix before a file extension
#'
#' Inserts a suffix between the file stem and extension.
#'
#' @param x A character vector.
#' @param suffix A suffix to add.
#' @param overwrite Logical. Should the input paths be returned unchanged?
#'
#' @returns A character vector of file paths.
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
#' Adds an incrementing numeric suffix when a path already exists.
#'
#' @param x A file path.
#' @param overwrite Logical. Should an existing file be overwritten?
#'
#' @returns A file path.
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
