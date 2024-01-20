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
  expect_snapshot(dm[, -c(1, 2)])
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
    "optimized:"
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
  skip("TODO: Finish tests")
})
