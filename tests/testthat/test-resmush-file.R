test_that("resmush_file() reports offline status when service is unavailable", {
  test_dir <- local_inst_dir()
  test_png <- file.path(test_dir, "example.png")
  expect_true(file.exists(test_png))

  local_mocked_bindings(resmush_is_online = function() FALSE)

  expect_silent(dm <- resmush_file(test_png, report = FALSE))

  expect_s3_class(dm, "data.frame")
  expect_equal(dm$src_img, test_png)
  expect_identical(dm$notes, "Offline.")
  expect_all_true(is.na(dm$dest_img))

  unlink(test_dir, recursive = TRUE, force = TRUE)
})

test_that("resmush_file() reports failed optimized-image downloads", {
  test_dir <- local_inst_dir()
  test_png <- file.path(test_dir, "example.png")
  expect_true(file.exists(test_png))

  local_mocked_bindings(
    resmush_is_online = function() TRUE,
    smush_from_local = function(...) list(dest = "https://example.com/image"),
    download_optimized_file = function(...) {
      structure(list(), class = "httr2_response")
    }
  )
  local_mocked_bindings(resmush_resp_status = function(resp) 503L)

  suppressMessages(dm <- resmush_file(test_png))

  expect_s3_class(dm, "data.frame")
  expect_equal(dm$src_img, test_png)
  expect_identical(
    dm$notes,
    "The API is not responding. Check https://resmush.it/status."
  )
  expect_all_true(is.na(dm$dest_img))

  unlink(test_dir, recursive = TRUE, force = TRUE)
})

test_that("resmush_file() reports API responses without destinations", {
  test_dir <- local_inst_dir()
  test_png <- file.path(test_dir, "example.png")

  local_mocked_bindings(
    resmush_is_online = function() TRUE,
    smush_from_local = function(...) list(unexpected = TRUE)
  )

  expect_silent(dm <- resmush_file(test_png, progress = FALSE, report = FALSE))

  expect_s3_class(dm, "data.frame")
  expect_identical(
    dm$notes,
    "The API is not responding. Check https://resmush.it/status."
  )
  expect_all_true(is.na(dm$dest_img))

  unlink(test_dir, recursive = TRUE, force = TRUE)
})

test_that("resmush_file() writes files from successful API results", {
  test_png <- local_inst_file("example.png")
  expected_output <- add_suffix(test_png)

  local_mocked_bindings(
    resmush_is_online = function() TRUE,
    smush_from_local = function(...) {
      list(dest = "https://example.com/optimized.png")
    },
    download_optimized_file = function(url, outfile, src, source_type) {
      file.copy(src, outfile, overwrite = TRUE)
      httr2::response(status_code = 200)
    }
  )

  expect_silent(dm <- resmush_file(test_png, progress = FALSE, report = FALSE))

  expect_s3_class(dm, "data.frame")
  expect_identical(dm$src_img, test_png)
  expect_identical(dm$dest_img, expected_output)
  expect_true(file.exists(expected_output))
  expect_identical(dm$src_bytes, dm$dest_bytes)
  expect_identical(dm$compress_ratio, "0.00%")
  expect_identical(dm$notes, "OK")
})


test_that("resmush_file() reports nonexistent local files", {
  fl <- withr::local_tempfile()

  expect_false(file.exists(fl))

  local_mocked_bindings(resmush_is_online = function() TRUE)

  suppressMessages(dm <- resmush_file(fl))

  expect_s3_class(dm, "data.frame")
  expect_equal(dm$src_img, fl)
  expect_identical(dm$notes, "Local file does not exist.")
  expect_all_true(is.na(dm$dest_img))
  unlink(fl, force = TRUE)
})

test_that("resmush_file() reports unsupported local file extensions", {
  fl <- withr::local_tempfile(fileext = ".txt")

  writeLines("testing a fake file", con = fl)
  expect_true(file.exists(fl))

  local_mocked_bindings(
    resmush_is_online = function() TRUE,
    smush_from_local = function(...) {
      list(
        error = 403,
        error_long = "Unauthorized extension. Allowed are : JPG, PNG"
      )
    }
  )

  suppressMessages(dm <- resmush_file(fl))

  expect_s3_class(dm, "data.frame")
  expect_equal(dm$src_img, fl)
  expect_identical(
    dm$notes,
    paste0(
      "403: The file extension is not supported. Allowed extensions are JPG, ",
      "PNG, GIF, BMP and TIFF."
    )
  )
  expect_all_true(is.na(dm$dest_img))
  unlink(fl, force = TRUE, recursive = TRUE)
})

test_that("resmush_file() adds the default suffix to PNG outputs", {
  skip_on_cran()
  skip_if_offline()

  test_dir <- local_inst_dir()
  test_png <- file.path(test_dir, "example.png")

  # Make output
  theout <- add_suffix(test_png)

  expect_true(file.exists(test_png))
  expect_false(file.exists(theout))

  suppressMessages(dm <- resmush_file(test_png))

  expect_s3_class(dm, "data.frame")
  expect_false(anyNA(dm))
  expect_equal(dm$src_img, test_png)
  expect_true(file.exists(theout))
  expect_equal(basename(dm$dest_img), "example_resmush.png")

  ratio <- as.double(gsub("%", "", dm$compress_ratio, fixed = TRUE))
  expect_gte(ratio, 0)
  expect_lt(ratio, 100)
  unlink(test_dir, recursive = TRUE, force = TRUE)
})

test_that("resmush_file() overwrites source files when suffix is empty", {
  skip_on_cran()
  skip_if_offline()
  test_dir <- local_inst_dir()
  list.files(test_dir)
  test_png <- file.path(test_dir, "example.png")
  expect_true(file.exists(test_png))
  ins <- file.size(test_png)

  # Make output
  theout <- add_suffix(test_png, suffix = "_resmush")
  expect_false(file.exists(theout))
  suppressMessages(dm <- resmush_file(test_png, suffix = ""))

  expect_false(file.exists(theout))
  expect_s3_class(dm, "data.frame")
  expect_false(anyNA(dm))
  expect_equal(dm$src_img, test_png)
  expect_equal(dm$dest_img, dm$src_img)

  outs <- file.size(test_png)
  expect_lt(outs, ins)

  # Check units
  fmrted <- make_pretty_size(ins)
  expect_identical(dm$src_size, fmrted)
  unlink(test_dir, recursive = TRUE, force = TRUE)
})

test_that("resmush_file() applies JPEG quality settings", {
  skip_on_cran()
  skip_if_offline()
  test_dir <- local_inst_dir()
  test_jpg <- file.path(test_dir, "example.jpg")

  expect_true(file.exists(test_jpg))
  outf <- add_suffix(test_jpg, "a_jpg_qlty")
  expect_false(file.exists(outf))
  suppressMessages(dm <- resmush_file(test_jpg, suffix = "a_jpg_qlty"))

  expect_true(file.exists(outf))
  expect_s3_class(dm, "data.frame")
  expect_false(anyNA(dm))
  expect_equal(dm$src_img, test_jpg)

  ins <- file.size(test_jpg)
  outs <- file.size(outf)
  expect_lt(outs, ins)

  # Check units
  fmrted <- make_pretty_size(ins)
  expect_identical(dm$src_size, fmrted)

  # Use qlty
  resmush_clean_dir(test_dir, "_even_lower")
  outf2 <- add_suffix(test_jpg, "_even_lower")
  expect_false(file.exists(outf2))
  dm2 <- resmush_file(test_jpg, suffix = "_even_lower", qlty = 30)

  expect_true(file.exists(outf2))
  out2s <- file.size(outf2)

  expect_lt(out2s, outs)
  unlink(test_dir, force = TRUE, recursive = TRUE)
})


test_that("resmush_file() processes mixed inputs with progress enabled", {
  skip_on_cran()
  skip_if_offline()

  # tempfile
  no_file <- withr::local_tempfile()

  # Bad extension
  # tempfile
  bad_ext <- withr::local_tempfile(fileext = ".txt")

  writeLines("testing a fake file", con = bad_ext)
  jpg_file <- local_inst_file("example.jpg")
  png_file <- local_inst_file("example.png")

  all_in <- c(png_file, no_file, jpg_file, bad_ext)

  res_all <- add_suffix(all_in)

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

  expect_message(dm <- resmush_file(all_in), "reSmushing")

  expect_identical(options(cli_options), expected_options)

  expect_equal(nrow(dm), 4)
  expect_equal(dm$src_img, all_in)
  expect_equal(
    basename(dm$dest_img),
    basename(c(res_all[1], NA, res_all[3], NA))
  )

  unlink(all_in, force = TRUE, recursive = TRUE)
})
test_that("resmush_file() processes mixed inputs with progress disabled", {
  skip_on_cran()
  skip_if_offline()

  # tempfile
  no_file <- withr::local_tempfile()

  # Bad extension
  # tempfile
  bad_ext <- withr::local_tempfile(fileext = ".txt")

  writeLines("testing a fake file", con = bad_ext)
  jpg_file <- local_inst_file("example.jpg")
  png_file <- local_inst_file("example.png")

  all_in <- c(png_file, no_file, jpg_file, bad_ext)

  res_all <- add_suffix(all_in)

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
  expect_silent(dm <- resmush_file(all_in, progress = FALSE, report = FALSE))

  expect_identical(options(cli_options), expected_options)

  expect_equal(nrow(dm), 4)
  expect_equal(dm$src_img, all_in)
  expect_equal(
    basename(dm$dest_img),
    basename(c(res_all[1], NA, res_all[3], NA))
  )

  unlink(all_in, force = TRUE, recursive = TRUE)
})

test_that("resmush_file() preserves EXIF metadata when requested", {
  skip_on_cran()
  skip_if_offline()
  exif_dir <- withr::local_tempdir(pattern = "resmush-exif-")
  exif <- file.path(exif_dir, "exif.jpg")

  res <- httr2::request(paste0(
    "https://dieghernan.github.io/resmush/",
    "img/sample-jpg-exif-876kb.jpg"
  ))

  resmush_req_perform(res, path = exif)

  expect_true(file.exists(exif))
  resmush_clean_dir(exif_dir, "_without_exif")
  resmush_clean_dir(exif_dir, "_with_exif")

  # With EXIF
  dm <- resmush_file(exif, "_without_exif", exif_preserve = FALSE)
  dm2 <- resmush_file(exif, "_with_exif", exif_preserve = TRUE)

  expect_lt(file.size(dm$dest_img), file.size(dm2$dest_img))
  expect_snapshot(
    resmush_clean_dir(exif_dir, "_without_exif"),
    transform = scrub_snapshot_paths
  )
  expect_snapshot(
    resmush_clean_dir(exif_dir, "_with_exif"),
    transform = scrub_snapshot_paths
  )
})

test_that("resmush_file() overwrites existing outputs when enabled", {
  skip_on_cran()
  skip_if_offline()

  test_png <- local_inst_file("example.png", "overr_file")
  expect_true(file.exists(test_png))
  ins <- file.size(test_png)

  # Extract dir
  out_dir <- dirname(test_png)

  # Make output
  theout <- add_suffix(test_png, suffix = "_resmush")
  expect_false(file.exists(theout))

  expect_snapshot(
    dm <- resmush_file(
      test_png,
      suffix = "_resmush",
      overwrite = TRUE,
      progress = FALSE
    ),
    transform = scrub_snapshot_paths
  )

  expect_false(file.exists(theout))
  expect_s3_class(dm, "data.frame")
  expect_false(anyNA(dm))
  expect_equal(dm$src_img, test_png)
  expect_equal(dm$dest_img, dm$src_img)

  outs <- file.size(test_png)
  expect_lt(outs, ins)

  # No new files
  expect_length(list.files(out_dir, pattern = "png$"), 1)

  unlink(out_dir, force = TRUE, recursive = TRUE)
})
test_that("resmush_file() returns NULL after HTTP download errors", {
  test_dir <- local_inst_dir()
  test_png <- file.path(test_dir, "example.png")
  expect_true(file.exists(test_png))

  local_mocked_bindings(
    resmush_is_online = function() TRUE,
    smush_from_local = function(...) list(dest = "https://example.com/image")
  )
  local_mocked_bindings(
    resmush_req_perform = function(req, path = NULL) {
      structure(list(), class = "httr2_response")
    },
    resmush_resp_is_error = function(resp) TRUE,
    resmush_resp_status = function(resp) 404L,
    resmush_resp_status_desc = function(resp) "Not Found"
  )

  expect_snapshot(
    dm <- resmush_file(test_png, progress = FALSE),
    transform = scrub_snapshot_paths
  )
  expect_null(dm)

  unlink(test_dir, recursive = TRUE, force = TRUE)
})
