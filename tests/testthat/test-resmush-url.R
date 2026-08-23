test_that("resmush_url() reports offline status when service is unavailable", {
  png_url <- paste0(
    "https://raw.githubusercontent.com/",
    "dieghernan/resmush/main/inst/",
    "extimg/example.png"
  )

  local_mocked_bindings(
    resmush_is_online = function() FALSE
  )

  suppressMessages(dm <- resmush_url(png_url))

  expect_s3_class(dm, "data.frame")
  expect_identical(dm$notes, "Offline.")
  expect_all_true(is.na(dm$dest_img))
})

test_that("resmush_url() reports failed optimized-image downloads", {
  png_url <- paste0(
    "https://raw.githubusercontent.com/",
    "dieghernan/resmush/main/inst/",
    "extimg/example.png"
  )

  local_mocked_bindings(
    resmush_is_online = function() TRUE,
    smush_from_url = function(...) {
      list(dest = "https://example.com/image", src_size = 1000)
    },
    download_optimized_file = function(...) {
      structure(list(), class = "httr2_response")
    }
  )
  local_mocked_bindings(resmush_resp_status = function(resp) 503L)

  suppressMessages(dm <- resmush_url(png_url))

  expect_s3_class(dm, "data.frame")
  expect_identical(
    dm$notes,
    "The API is not responding. Check https://resmush.it/status."
  )
  expect_all_true(is.na(dm$dest_img))

  unlink(file.path(tempdir(), basename(dm$src_img)))
})

test_that("resmush_url() reports API responses without destination URLs", {
  png_url <- "https://example.com/example.png"
  outfile <- withr::local_tempfile(fileext = ".png")

  local_mocked_bindings(
    resmush_is_online = function() TRUE,
    smush_from_url = function(...) list(unexpected = TRUE)
  )

  expect_silent(
    dm <- resmush_url(
      png_url,
      outfile = outfile,
      progress = FALSE,
      report = FALSE
    )
  )

  expect_s3_class(dm, "data.frame")
  expect_identical(
    dm$notes,
    "The API is not responding. Check https://resmush.it/status."
  )
  expect_all_true(is.na(dm$dest_img))
  expect_false(file.exists(outfile))
})

test_that("resmush_url() writes files from successful API results", {
  source_file <- local_inst_file("example.png")
  outfile <- withr::local_tempfile(fileext = ".png")
  url <- "https://example.com/example.png"

  local_mocked_bindings(
    resmush_is_online = function() TRUE,
    smush_from_url = function(...) {
      list(
        dest = "https://example.com/optimized.png",
        src_size = file.size(source_file)
      )
    },
    download_optimized_file = function(url, outfile, src, source_type) {
      file.copy(source_file, outfile, overwrite = TRUE)
      httr2::response(status_code = 200)
    }
  )

  expect_silent(
    dm <- resmush_url(
      url,
      outfile,
      progress = FALSE,
      report = FALSE
    )
  )

  expect_s3_class(dm, "data.frame")
  expect_identical(dm$src_img, url)
  expect_identical(dm$dest_img, outfile)
  expect_true(file.exists(outfile))
  expect_identical(dm$src_bytes, dm$dest_bytes)
  expect_identical(dm$compress_ratio, "0.00%")
  expect_identical(dm$notes, "OK")
})

test_that("resmush_url() reports inaccessible image URLs", {
  skip_on_cran()
  skip_if_offline()

  turl <- "https://dieghernan.github.io/aaabbbccc.png"

  suppressMessages(dm <- resmush_url(turl))

  expect_s3_class(dm, "data.frame")
  expect_identical(
    dm$notes,
    "401: The API could not retrieve the remote URL."
  )
  expect_all_true(is.na(dm$dest_img))
})

test_that("resmush_url() reports URLs with unsupported extensions", {
  skip_on_cran()
  skip_if_offline()

  turl <- paste0(
    "https://raw.githubusercontent.com/",
    "dieghernan/resmush/main/README.md"
  )

  suppressMessages(dm <- resmush_url(turl))

  expect_s3_class(dm, "data.frame")
  expect_identical(
    dm$notes,
    paste0(
      "403: The file extension is not supported. Allowed extensions are JPG, ",
      "PNG, GIF, BMP and TIFF."
    )
  )
  expect_all_true(is.na(dm$dest_img))
})

test_that("resmush_url() writes PNG outputs to the default location", {
  source_file <- local_inst_file("example.png")
  unique_name <- paste0(basename(withr::local_tempfile()), ".png")
  png_url <- paste0("https://example.com/", unique_name)
  out_f <- file.path(tempdir(), basename(png_url))
  withr::defer(unlink(out_f, force = TRUE))

  local_mocked_bindings(
    resmush_is_online = function() TRUE,
    smush_from_url = function(...) {
      list(
        dest = "https://example.com/optimized.png",
        src_size = file.size(source_file)
      )
    },
    download_optimized_file = function(url, outfile, src, source_type) {
      file.copy(source_file, outfile, overwrite = TRUE)
      httr2::response(status_code = 200)
    }
  )

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

  suppressMessages(dm <- resmush_url(png_url))

  expect_identical(options(cli_options), expected_options)

  expect_s3_class(dm, "data.frame")
  expect_false(anyNA(dm))
  expect_identical(dm$src_img, png_url)
  expect_identical(dm$dest_img, out_f)

  ratio <- as.double(gsub("%", "", dm$compress_ratio, fixed = TRUE))
  expect_gte(ratio, 0)
  expect_lt(ratio, 100)
})


test_that("resmush_url() writes PNG outputs to explicit paths", {
  skip_on_cran()
  skip_if_offline()

  png_url <- paste0(
    "https://raw.githubusercontent.com/",
    "dieghernan/resmush/main/inst/",
    "extimg/example.png"
  )

  outf <- withr::local_tempfile(fileext = ".png")
  expect_false(file.exists(outf))
  suppressMessages(dm <- resmush_url(png_url, outf))

  expect_true(file.exists(outf))
  expect_s3_class(dm, "data.frame")
  expect_false(anyNA(dm))
  expect_equal(dm$src_img, png_url)

  outs <- file.size(outf)

  # Check units
  fmrted <- make_pretty_size(outs)
  expect_identical(dm$dest_size, fmrted)
  unlink(dm$dest_img, recursive = TRUE, force = TRUE)
})

test_that("resmush_url() applies JPEG quality settings", {
  skip_on_cran()
  skip_if_offline()

  jpg_url <- paste0(
    "https://raw.githubusercontent.com/",
    "dieghernan/resmush/main/inst/",
    "extimg/example.jpg"
  )

  outf <- withr::local_tempfile(fileext = ".jpg")
  expect_false(file.exists(outf))
  suppressMessages(dm <- resmush_url(jpg_url, outf))

  expect_true(file.exists(outf))
  expect_s3_class(dm, "data.frame")
  expect_false(anyNA(dm))
  expect_equal(dm$src_img, jpg_url)
  expect_equal(basename(dm$dest_img), basename(outf))

  outs <- file.size(outf)

  # Use qlty
  outf2 <- withr::local_tempfile(fileext = ".jpg")
  dm2 <- resmush_url(jpg_url, outf2, qlty = 30)

  expect_true(file.exists(outf2))
  out2s <- file.size(outf2)

  expect_lt(out2s, outs)
})

test_that("resmush_url() rejects unequal URL and output path lengths", {
  png_url <- paste0(
    "https://raw.githubusercontent.com/",
    "dieghernan/resmush/main/inst/",
    "extimg/example.png"
  )

  jpg_url <- paste0(
    "https://raw.githubusercontent.com/",
    "dieghernan/resmush/main/inst/",
    "extimg/example.jpg"
  )

  two_input <- c(png_url, jpg_url)
  several_outputs <- LETTERS[1:3]

  expect_snapshot(dm <- resmush_url(two_input, several_outputs), error = TRUE)
})

test_that("resmush_url() processes mixed URLs with default output paths", {
  skip_on_cran()
  skip_if_offline()

  # No url
  turl <- "https://dieghernan.github.io/aaabbbccc.png"

  # Not valid
  notval <- paste0(
    "https://raw.githubusercontent.com/",
    "dieghernan/resmush/main/README.md"
  )

  png_url <- paste0(
    "https://raw.githubusercontent.com/",
    "dieghernan/resmush/main/inst/",
    "extimg/example.png"
  )

  jpg_url <- paste0(
    "https://raw.githubusercontent.com/",
    "dieghernan/resmush/main/inst/",
    "extimg/example.jpg"
  )

  all_in <- c(png_url, notval, jpg_url, turl)

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

  expect_silent(dm <- resmush_url(all_in, report = FALSE, progress = FALSE))

  expect_identical(options(cli_options), expected_options)

  expect_equal(nrow(dm), 4)
  expect_equal(dm$src_img, all_in)

  expect_equal(is.na(dm$dest_img), c(FALSE, TRUE, FALSE, TRUE))
  unlink(dm$dest_img, recursive = TRUE, force = TRUE)
})


test_that("resmush_url() processes mixed URLs with explicit output paths", {
  skip_on_cran()
  skip_if_offline()

  # No url
  turl <- "https://dieghernan.github.io/aaabbbccc.png"

  # Not valid
  notval <- paste0(
    "https://raw.githubusercontent.com/",
    "dieghernan/resmush/main/README.md"
  )

  png_url <- paste0(
    "https://raw.githubusercontent.com/",
    "dieghernan/resmush/main/inst/",
    "extimg/example.png"
  )

  jpg_url <- paste0(
    "https://raw.githubusercontent.com/",
    "dieghernan/resmush/main/inst/",
    "extimg/example.jpg"
  )

  all_in <- c(png_url, notval, jpg_url, turl)

  all_outs <- c(
    withr::local_tempfile(fileext = ".png"),
    withr::local_tempfile(fileext = ".png"),
    withr::local_tempfile(fileext = ".jpg"),
    withr::local_tempfile(fileext = ".png")
  )

  expect_length(unique(all_outs), 4)

  suppressMessages(dm <- resmush_url(all_in, all_outs))

  expect_equal(nrow(dm), 4)
  expect_equal(dm$src_img, all_in)
  expect_equal(
    basename(dm$dest_img),
    basename(c(all_outs[1], NA, all_outs[3], NA))
  )

  expect_all_true(file.exists(all_outs[c(1, 3)]))

  unlink(dm$dest_img, recursive = TRUE, force = TRUE)
})


test_that("resmush_url() disambiguates duplicate output paths", {
  skip_on_cran()
  skip_if_offline()

  png_url_single <- paste0(
    "https://raw.githubusercontent.com/",
    "dieghernan/resmush/main/inst/",
    "extimg/example.png"
  )

  png_url <- rep(png_url_single, 3)

  output_dir <- withr::local_tempdir(pattern = "duplicate-outputs-")
  outs <- file.path(output_dir, basename(png_url))

  if (any(file.exists(outs))) {
    unlink(outs, force = TRUE)
  }

  expect_false(file.exists(outs[1]))

  # But should be renamed as
  renamed <- file.path(output_dir, c("example_01.png", "example_02.png"))
  if (any(file.exists(renamed))) {
    unlink(renamed, force = TRUE)
  }
  expect_all_false(file.exists(renamed))

  # Call
  suppressMessages(dm <- resmush_url(png_url, outs))

  # Check that now exists
  expect_all_true(file.exists(renamed))

  expect_equal(nrow(dm), 3)
  expect_equal(dm$src_img, png_url)
  expect_equal(basename(dm$dest_img), basename(c(outs[1], renamed)))
  unlink(dm$dest_img, recursive = TRUE, force = TRUE)
})


test_that("resmush_url() reuses duplicate paths when overwrite is enabled", {
  skip_on_cran()
  skip_if_offline()

  png_url_single <- paste0(
    "https://raw.githubusercontent.com/",
    "dieghernan/resmush/main/inst/",
    "extimg/example.png"
  )

  png_url <- rep(png_url_single, 3)

  output_dir <- withr::local_tempdir(pattern = "overwrite-outputs-")
  outs <- file.path(output_dir, basename(png_url))
  the_dir <- unique(dirname(outs))

  if (any(file.exists(outs))) {
    unlink(outs, force = TRUE)
  }

  expect_false(file.exists(outs[1]))

  # Call with override
  suppressMessages(dm <- resmush_url(png_url, outs, overwrite = TRUE))

  expect_equal(nrow(dm), 3)
  expect_equal(dm$src_img, png_url)
  expect_equal(basename(dm$dest_img), basename(outs))

  # Check length, should be one
  ll <- list.files(the_dir, pattern = "png$")
  expect_length(ll, 1)
  expect_identical(ll, "example.png")

  unlink(the_dir, force = TRUE, recursive = TRUE)
})


test_that("resmush_url() creates missing output directories", {
  skip_on_cran()
  skip_if_offline()

  png_url <- paste0(
    "https://raw.githubusercontent.com/",
    "dieghernan/resmush/main/inst/",
    "extimg/example.png"
  )

  output_root <- withr::local_tempdir(pattern = "resmush-output-")
  outf <- file.path(output_root, "nested")
  expect_false(dir.exists(outf))
  outs <- file.path(outf, basename(png_url))

  # Call
  suppressMessages(dm <- resmush_url(png_url, outs))

  # Check that now exists
  expect_true(dir.exists(outf))
  expect_true(file.exists(outs))

  # Clean up
  unlink(outf, force = TRUE, recursive = TRUE)
})

test_that("resmush_url() returns NULL after HTTP download errors", {
  png_url <- paste0(
    "https://raw.githubusercontent.com/",
    "dieghernan/resmush/main/inst/",
    "extimg/example.png"
  )

  local_mocked_bindings(
    resmush_is_online = function() TRUE,
    smush_from_url = function(...) {
      list(dest = "https://example.com/image", src_size = 1000)
    }
  )
  local_mocked_bindings(
    resmush_req_perform = function(req, path = NULL) {
      structure(list(), class = "httr2_response")
    },
    resmush_resp_is_error = function(resp) TRUE,
    resmush_resp_status = function(resp) 404L,
    resmush_resp_status_desc = function(resp) "Not Found"
  )

  suppressMessages(dm <- resmush_url(png_url))

  expect_null(dm)
})
