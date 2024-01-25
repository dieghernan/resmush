test_that("Test offline", {
  skip_on_cran()
  test_png <- load_inst_to_temp("example.png")
  expect_true(file.exists(test_png))

  # Options for testing
  ops <- options()
  options(resmush_test_offline = TRUE)

  expect_true("resmush_test_offline" %in% names(options()))

  expect_snapshot(dm <- resmush_file(test_png))

  expect_s3_class(dm, "data.frame")
  expect_snapshot(dm[, -1])

  expect_equal(dm$src_img, test_png)

  # Reset ops
  options(resmush_test_offline = NULL)
  expect_false("resmush_test_offline" %in% names(options()))
})

test_that("Test corner", {
  skip_on_cran()
  skip_if_offline()

  test_png <- load_inst_to_temp("example.png")
  expect_true(file.exists(test_png))

  # Options for testing
  ops <- options()
  options(resmush_test_corner = TRUE)

  expect_true("resmush_test_corner" %in% names(options()))

  expect_snapshot(dm <- resmush_file(test_png))

  expect_s3_class(dm, "data.frame")
  expect_snapshot(dm[, -c(1, 3)])

  expect_equal(dm$src_img, test_png)

  # Reset ops
  options(resmush_test_corner = NULL)
  expect_false("resmush_test_corner" %in% names(options()))
})


test_that("Test not provided file", {
  skip_on_cran()
  skip_if_offline()

  # tempfile
  fl <- tempfile()

  expect_false(file.exists(fl))

  expect_message(
    dm <- resmush_file(fl),
    "not found on disk"
  )

  expect_s3_class(dm, "data.frame")
  expect_snapshot(dm[, -1])

  expect_equal(dm$src_img, fl)
})

test_that("Not valid file", {
  skip_on_cran()
  skip_if_offline()

  # tempfile
  fl <- tempfile(, fileext = "txt")

  writeLines("testing a fake file", con = fl)
  expect_true(file.exists(fl))

  expect_message(
    dm <- resmush_file(fl),
    "API Error"
  )

  expect_s3_class(dm, "data.frame")
  expect_snapshot(dm[, -c(1, 3)])
  expect_false(is.na(dm$src_img))
  expect_equal(dm$src_img, fl)
})

test_that("Test default opts with png", {
  skip_on_cran()
  skip_if_offline()

  resmush_clean_dir(tempdir())
  test_png <- load_inst_to_temp("example.png")

  # Make output
  theout <- add_suffix(test_png)

  expect_true(file.exists(test_png))
  expect_false(file.exists(theout))

  expect_silent(dm <- resmush_file(test_png))

  expect_s3_class(dm, "data.frame")
  expect_false(any(is.na(dm)))
  expect_equal(dm$src_img, test_png)
  expect_true(file.exists(theout))
  expect_equal(basename(dm$dest_img), "example_resmush.png")

  ratio <- as.double(gsub("%", "", dm$compress_ratio))
  expect_lt(ratio, 100)
})


test_that("Test opts with png", {
  skip_on_cran()
  skip_if_offline()
  resmush_clean_dir(tempdir())
  test_png <- load_inst_to_temp("example.png")
  expect_true(file.exists(test_png))
  ins <- file.size(test_png)

  # Make output
  theout <- add_suffix(test_png, suffix = "_resmush")
  expect_false(file.exists(theout))
  expect_message(
    dm <- resmush_file(test_png, suffix = "", verbose = TRUE),
    "Optimizing"
  )

  expect_false(file.exists(theout))
  expect_s3_class(dm, "data.frame")
  expect_false(any(is.na(dm)))
  expect_equal(dm$src_img, test_png)
  expect_equal(dm$dest_img, dm$src_img)

  outs <- file.size(test_png)
  expect_lt(outs, ins)

  # Check units
  unts <- make_object_size(ins)
  anobj <- object.size(unts)
  expect_s3_class(unts, class(unts))
  fmrted <- format(unts, "auto")

  expect_identical(dm$src_size, fmrted)
})

test_that("Test qlty par with jpg", {
  skip_on_cran()
  skip_if_offline()

  resmush_clean_dir(tempdir(), "a_jpg_qlty")
  test_jpg <- load_inst_to_temp("example.jpg")
  expect_true(file.exists(test_jpg))
  outf <- add_suffix(test_jpg, "a_jpg_qlty")
  expect_false(file.exists(outf))
  expect_message(
    dm <- resmush_file(test_jpg, suffix = "a_jpg_qlty", verbose = TRUE),
    "Optimizing"
  )

  expect_true(file.exists(outf))
  expect_s3_class(dm, "data.frame")
  expect_false(any(is.na(dm)))
  expect_equal(dm$src_img, test_jpg)

  ins <- file.size(test_jpg)
  outs <- file.size(outf)
  expect_lt(outs, ins)

  # Check units
  unts <- make_object_size(ins)
  anobj <- object.size(unts)
  expect_s3_class(unts, class(unts))
  fmrted <- format(unts, "auto")

  expect_identical(dm$src_size, fmrted)

  # Use qlty
  resmush_clean_dir(tempdir(), "_even_lower")
  outf2 <- add_suffix(test_jpg, "_even_lower")
  expect_false(file.exists(outf2))
  dm2 <- resmush_file(test_jpg, suffix = "_even_lower", qlty = 30)

  expect_true(file.exists(outf2))
  out2s <- file.size(outf2)

  expect_lt(out2s, outs)
})



test_that("Test full vectors", {
  skip_on_cran()
  skip_if_offline()

  # tempfile
  no_file <- tempfile()

  # Bad extension
  # tempfile
  bad_ext <- tempfile(, fileext = ".txt")

  writeLines("testing a fake file", con = bad_ext)
  jpg_file <- load_inst_to_temp("example.jpg")
  png_file <- load_inst_to_temp("example.png")

  all_in <- c(png_file, no_file, jpg_file, bad_ext)

  res_all <- add_suffix(all_in)

  resmush_clean_dir(tempdir())

  expect_message(
    dm <- resmush_file(all_in),
    "not found on disk"
  )

  expect_equal(nrow(dm), 4)
  expect_equal(dm$src_img, all_in)
  expect_equal(basename(dm$dest_img), basename(c(
    res_all[1], NA, res_all[3],
    NA
  )))
})


test_that("Test exif", {
  skip_on_cran()
  skip_if_offline()
  exif <- tempfile("exif", fileext = ".jpg")

  res <- httr::GET(
    url = paste0(
      "https://raw.githubusercontent.com/dieghernan/resmush/main/",
      "img/sample-jpg-exif-876kb.jpg"
    ),
    httr::write_disk(exif, overwrite = TRUE)
  )

  expect_true(file.exists(exif))
  resmush_clean_dir(tempdir(), "_without_exif")
  resmush_clean_dir(tempdir(), "_with_exif")

  # With exif
  dm <- resmush_file(exif, "_without_exif", exif_preserve = FALSE)
  dm2 <- resmush_file(exif, "_with_exif", exif_preserve = TRUE)

  expect_lt(file.size(dm$dest_img), file.size(dm2$dest_img))
})

test_that("Test override", {
  skip_on_cran()
  skip_if_offline()

  resmush_clean_dir(tempdir())

  test_png <- load_inst_to_temp("example.png", "overr_file")
  expect_true(file.exists(test_png))
  ins <- file.size(test_png)

  # Extract dir
  out_dir <- dirname(test_png)

  # Make output
  theout <- add_suffix(test_png, suffix = "_resmush")
  expect_false(file.exists(theout))

  expect_silent(
    dm <- resmush_file(test_png, suffix = "_resmush", overwrite = TRUE)
  )

  expect_false(file.exists(theout))
  expect_s3_class(dm, "data.frame")
  expect_false(any(is.na(dm)))
  expect_equal(dm$src_img, test_png)
  expect_equal(dm$dest_img, dm$src_img)

  outs <- file.size(test_png)
  expect_lt(outs, ins)

  # No new files
  expect_length(list.files(out_dir, pattern = "png$"), 1)

  unlink(out_dir, force = TRUE)
})
