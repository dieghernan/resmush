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
  test_png <- load_inst_to_temp("example.png")
  expect_true(file.exists(test_png))

  expect_silent(dm <- resmush_file(test_png))

  expect_s3_class(dm, "data.frame")
  expect_false(any(is.na(dm)))
  expect_equal(dm$src_img, test_png)
  expect_equal(dm$dest_img, test_png)

  ratio <- as.double(gsub("%", "", dm$compress_ratio))
  expect_lt(ratio, 100)
})


test_that("Test opts with png", {
  skip_on_cran()
  skip_if_offline()
  test_png <- load_inst_to_temp("example.png")
  expect_true(file.exists(test_png))
  outf <- tempfile(fileext = ".png")
  expect_false(file.exists(outf))
  expect_message(
    dm <- resmush_file(test_png,
      outf,
      verbose = TRUE
    ),
    "Optimizing"
  )

  expect_true(file.exists(outf))
  expect_s3_class(dm, "data.frame")
  expect_false(any(is.na(dm)))
  expect_equal(dm$src_img, test_png)
  expect_equal(dm$dest_img, outf)

  ins <- file.size(test_png)
  outs <- file.size(outf)
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

  test_jpg <- load_inst_to_temp("example.jpg")
  expect_true(file.exists(test_jpg))
  outf <- tempfile(fileext = ".jpg")
  expect_false(file.exists(outf))
  expect_message(
    dm <- resmush_file(test_jpg,
      outf,
      verbose = TRUE
    ),
    "Optimizing"
  )

  expect_true(file.exists(outf))
  expect_s3_class(dm, "data.frame")
  expect_false(any(is.na(dm)))
  expect_equal(dm$src_img, test_jpg)
  expect_equal(dm$dest_img, outf)

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
  outf2 <- tempfile(fileext = ".jpg")
  dm2 <- resmush_file(test_jpg, outf2, qlty = 30)

  expect_true(file.exists(outf2))
  out2s <- file.size(outf2)

  expect_lt(out2s, outs)
})


test_that("Test errors in lengths", {
  skip_on_cran()

  two_input <- rep(load_inst_to_temp("example.jpg"), 2)
  expect_equal(length(two_input), 2)

  several_outputs <- LETTERS[1:3]

  expect_snapshot(
    dm <- resmush_file(two_input, several_outputs),
    error = TRUE
  )
})

test_that("Test full vectors without outfile", {
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

  expect_message(
    dm <- resmush_file(all_in),
    "not found on disk"
  )

  expect_equal(nrow(dm), 4)
  expect_equal(dm$src_img, all_in)
  expect_equal(dm$dest_img, c(all_in[1], NA, all_in[3], NA))
})


test_that("Test full vectors with outfile", {
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

  all_outs <- c(
    tempfile(fileext = ".png"),
    tempfile(fileext = ".png"),
    tempfile(fileext = ".jpg"),
    tempfile(fileext = ".png")
  )

  expect_length(unique(all_outs), 4)

  expect_message(
    dm <- resmush_file(all_in, all_outs),
    "not found on disk"
  )

  expect_equal(nrow(dm), 4)
  expect_equal(dm$src_img, all_in)
  expect_equal(dm$dest_img, c(all_outs[1], NA, all_outs[3], NA))

  expect_true(all(file.exists(all_outs[c(1, 3)])))
})
