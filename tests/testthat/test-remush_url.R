test_that("Test offline", {
  skip_on_cran()

  png_url <- paste0(
    "https://raw.githubusercontent.com/",
    "dieghernan/resmush/main/inst/",
    "extimg/example.png"
  )

  # Options for testing
  ops <- options()
  options(resmush_test_offline = TRUE)

  expect_true("resmush_test_offline" %in% names(options()))

  expect_snapshot(dm <- resmush_url(png_url))

  expect_s3_class(dm, "data.frame")
  expect_snapshot(dm)

  # Reset ops
  options(resmush_test_offline = NULL)
  expect_false("resmush_test_offline" %in% names(options()))
})

test_that("Test corner", {
  skip_on_cran()
  png_url <- paste0(
    "https://raw.githubusercontent.com/",
    "dieghernan/resmush/main/inst/",
    "extimg/example.png"
  )

  # Options for testing
  ops <- options()
  options(resmush_test_corner = TRUE)

  expect_true("resmush_test_corner" %in% names(options()))

  expect_snapshot(dm <- resmush_url(png_url))

  expect_s3_class(dm, "data.frame")
  expect_snapshot(dm)


  # Reset ops
  options(resmush_test_corner = NULL)
  expect_false("resmush_test_corner" %in% names(options()))
})


test_that("Test not url", {
  skip_on_cran()
  skip_if_offline()

  turl <- "https://dieghernan.github.io/aaabbbccc.png"

  expect_snapshot(dm <- resmush_url(turl))

  expect_s3_class(dm, "data.frame")
  expect_snapshot(dm)
})

test_that("Not valid file", {
  skip_on_cran()
  skip_if_offline()

  turl <- paste0(
    "https://raw.githubusercontent.com/",
    "dieghernan/resmush/main/README.md"
  )

  expect_snapshot(dm <- resmush_url(turl))

  expect_s3_class(dm, "data.frame")
  expect_snapshot(dm)
})

test_that("Test default opts with png", {
  skip_on_cran()
  skip_if_offline()

  png_url <- paste0(
    "https://raw.githubusercontent.com/",
    "dieghernan/resmush/main/inst/",
    "extimg/example.png"
  )


  expect_silent(dm <- resmush_url(png_url))

  outf <- file.path(tempdir(), "example.png")

  expect_s3_class(dm, "data.frame")
  expect_false(any(is.na(dm)))
  expect_equal(dm$src_img, png_url)
  expect_equal(dm$dest_img, outf)

  ratio <- as.double(gsub("%", "", dm$compress_ratio))
  expect_lt(ratio, 100)
})


test_that("Test opts with png", {
  skip_on_cran()
  skip_if_offline()

  png_url <- paste0(
    "https://raw.githubusercontent.com/",
    "dieghernan/resmush/main/inst/",
    "extimg/example.png"
  )


  outf <- tempfile(fileext = ".png")
  expect_false(file.exists(outf))
  expect_message(
    dm <- resmush_url(png_url,
      outf,
      verbose = TRUE
    ),
    "Optimizing"
  )

  expect_true(file.exists(outf))
  expect_s3_class(dm, "data.frame")
  expect_false(any(is.na(dm)))
  expect_equal(dm$src_img, png_url)
  expect_equal(dm$dest_img, outf)


  outs <- file.size(outf)

  # Check units
  unts <- make_object_size(outs)
  anobj <- object.size(unts)
  expect_s3_class(unts, class(unts))
  fmrted <- format(unts, "auto")

  expect_identical(dm$dest_size, fmrted)
})

test_that("Test qlty par with jpg", {
  skip_on_cran()
  skip_if_offline()

  jpg_url <- paste0(
    "https://raw.githubusercontent.com/",
    "dieghernan/resmush/main/inst/",
    "extimg/example.jpg"
  )


  outf <- tempfile(fileext = ".jpg")
  expect_false(file.exists(outf))
  expect_message(
    dm <- resmush_url(jpg_url,
      outf,
      verbose = TRUE
    ),
    "Optimizing"
  )

  expect_true(file.exists(outf))
  expect_s3_class(dm, "data.frame")
  expect_false(any(is.na(dm)))
  expect_equal(dm$src_img, jpg_url)
  expect_equal(dm$dest_img, outf)

  outs <- file.size(outf)

  # Use qlty
  outf2 <- tempfile(fileext = ".jpg")
  dm2 <- resmush_url(jpg_url, outf2, qlty = 30)

  expect_true(file.exists(outf2))
  out2s <- file.size(outf2)

  expect_lt(out2s, outs)
})
