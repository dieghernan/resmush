test_that("add_suffix() inserts suffixes before file extensions", {
  unique_names <- c("./a/example.png", "b/example.jpg")
  expect_length(unique(unique_names), 2)
  same_res <- add_suffix(unique_names, suffix = "")
  same_res_na <- add_suffix(unique_names, suffix = NA)
  same_res_null <- add_suffix(unique_names, suffix = NULL)
  expect_identical(unique_names, same_res)
  expect_identical(unique_names, same_res_na)
  expect_identical(unique_names, same_res_null)

  # More extensions with suffix
  nodups <- c(
    "./test.png",
    "./a./dot./test.png.jpg",
    "./test.jpg",
    "./test.jpg.png"
  )

  # Default behaviour
  def <- add_suffix(nodups)
  expect_identical(
    c(
      "./test_resmush.png",
      "./a./dot./test.png_resmush.jpg",
      "./test_resmush.jpg",
      "./test.jpg_resmush.png"
    ),
    def
  )

  same_res2 <- add_suffix(nodups, suffix = "_asuffix")
  expect_identical(
    c(
      "./test_asuffix.png",
      "./a./dot./test.png_asuffix.jpg",
      "./test_asuffix.jpg",
      "./test.jpg_asuffix.png"
    ),
    same_res2
  )
})

test_that("response status descriptions are available", {
  resp <- httr2::response(status_code = 404)

  expect_identical(resmush_resp_status_desc(resp), "Not Found")
})

test_that("format_api_note() returns complete sentences", {
  notes <- c(
    "Offline",
    "Already complete.",
    "Try again!",
    "What now?",
    NA_character_,
    ""
  )

  expect_identical(
    format_resmush_note(notes),
    c(
      "Offline.",
      "Already complete.",
      "Try again!",
      "What now?",
      NA_character_,
      ""
    )
  )
})

test_that("format_api_note() normalizes API error messages", {
  expect_identical(
    format_api_note(
      403,
      "Unauthorized extension. Allowed are : JPG, PNG"
    ),
    paste0(
      "403: The file extension is not supported. Allowed extensions are JPG, ",
      "PNG, GIF, BMP and TIFF."
    )
  )
  expect_identical(
    format_api_note(401, "Cannot copy from remote url"),
    "401: The API could not retrieve the remote URL."
  )
  expect_identical(
    format_api_note(502, "Uploaded file must be below 5MB"),
    "502: The uploaded file must be smaller than 5 MB."
  )
  expect_identical(
    format_api_note(500, "Unexpected upstream wording"),
    "500: The API returned an error."
  )
  expect_identical(
    format_api_note(403, "UNAUTHORIZED EXTENSION"),
    paste0(
      "403: The file extension is not supported. Allowed extensions are JPG, ",
      "PNG, GIF, BMP and TIFF."
    )
  )
})

test_that("make_unique_paths() avoids existing paths unless overwriting", {
  test_dir <- withr::local_tempdir(pattern = "unique-paths-")
  path <- file.path(test_dir, "image.png")

  expect_identical(make_unique_paths(path, overwrite = FALSE), path)

  writeLines("original", path)
  path_01 <- file.path(test_dir, "image_01.png")
  path_02 <- file.path(test_dir, "image_02.png")

  expect_identical(make_unique_paths(path, overwrite = FALSE), path_01)

  writeLines("first duplicate", path_01)

  expect_identical(make_unique_paths(path, overwrite = FALSE), path_02)
  expect_identical(make_unique_paths(path, overwrite = TRUE), path)
})

test_that("resmush_map() returns NULL when all workers return NULL", {
  expect_null(
    resmush_map(
      character(),
      worker = \(i) NULL,
      progress = FALSE,
      progress_label = "file{?s}"
    )
  )
  expect_null(
    resmush_map(
      c("a", "b"),
      worker = \(i) NULL,
      progress = FALSE,
      progress_label = "file{?s}"
    )
  )
})

test_that("resmush_map() restores CLI options after worker errors", {
  cli_options <- c(
    "cli.progress_bar_style",
    "cli.progress_show_after",
    "cli.spinner"
  )
  withr::local_options(
    cli.progress_bar_style = "aaa",
    cli.progress_show_after = 1000,
    cli.spinner = "ccc"
  )
  expected_options <- options(cli_options)

  error <- suppressMessages(tryCatch(
    resmush_map(
      "input",
      worker = \(i) stop("Worker failed"),
      progress = TRUE,
      progress_label = "file{?s}"
    ),
    error = identity
  ))

  expect_s3_class(error, "simpleError")
  expect_identical(options(cli_options), expected_options)
})

test_that("scrub_snapshot_paths() masks temporary paths across platforms", {
  temp_path <- gsub("\\", "/", tempdir(), fixed = TRUE)
  temp_path <- gsub("/+$", "", temp_path)
  split_temp_path <- sub("/", "//", temp_path, fixed = TRUE)
  windows_temp_path <- gsub("/", "\\", temp_path, fixed = TRUE)

  scrubbed <- scrub_snapshot_paths(c(
    paste0("Saved in '", split_temp_path, "/resmush-dir-abc123'."),
    paste0("Saved in '", windows_temp_path, "\\resmush-exif-abc123'."),
    paste0("Saved in '", temp_path, "/working_dir/Rtmpabc123/ABCD/ABCD_1'."),
    "Remote URL: https://example.com/image.png"
  ))

  expect_identical(
    scrubbed,
    c(
      "Saved in '<tempdir>/resmush-dir-<id>'.",
      "Saved in '<tempdir>/resmush-exif-<id>'.",
      "Saved in '<tempdir>/<random-dir>'.",
      "Remote URL: https://example.com/image.png"
    )
  )
})
