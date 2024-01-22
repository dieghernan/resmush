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
  expect_equal(basename(dm$dest_img), basename(outf))

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
  expect_equal(basename(dm$dest_img), basename(outf))

  outs <- file.size(outf)

  # Use qlty
  outf2 <- tempfile(fileext = ".jpg")
  dm2 <- resmush_url(jpg_url, outf2, qlty = 30)

  expect_true(file.exists(outf2))
  out2s <- file.size(outf2)

  expect_lt(out2s, outs)
})



test_that("Test errors in lengths", {
  skip_on_cran()

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

  expect_snapshot(
    dm <- resmush_url(two_input, several_outputs),
    error = TRUE
  )
})

test_that("Test full vectors without outfile", {
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

  expect_message(
    dm <- resmush_url(all_in),
    "API Error"
  )

  expect_equal(nrow(dm), 4)
  expect_equal(dm$src_img, all_in)

  expect_equal(is.na(dm$dest_img), c(FALSE, TRUE, FALSE, TRUE))
})


test_that("Test full vectors with outfile", {
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
    tempfile(fileext = ".png"),
    tempfile(fileext = ".png"),
    tempfile(fileext = ".jpg"),
    tempfile(fileext = ".png")
  )

  expect_length(unique(all_outs), 4)

  expect_message(
    dm <- resmush_url(all_in, all_outs),
    "API Error"
  )

  expect_equal(nrow(dm), 4)
  expect_equal(dm$src_img, all_in)
  expect_equal(
    basename(dm$dest_img),
    basename(c(all_outs[1], NA, all_outs[3], NA))
  )

  expect_true(all(file.exists(all_outs[c(1, 3)])))
})


test_that("Handle duplicate names", {
  skip_on_cran()
  skip_if_offline()

  png_url_single <- paste0(
    "https://raw.githubusercontent.com/",
    "dieghernan/resmush/main/inst/",
    "extimg/example.png"
  )

  png_url <- rep(png_url_single, 2)

  outs <- file.path(tempdir(), basename(png_url))

  if (any(file.exists(outs))) unlink(outs, force = TRUE)

  expect_false(file.exists(outs[1]))

  # But should be renamed as
  renamed <- file.path(tempdir(), "example_1.png")
  if (any(file.exists(renamed))) unlink(renamed, force = TRUE)
  expect_false(file.exists(renamed))

  # Call
  expect_silent(dm <- resmush_url(png_url, outs))

  # Check that now exists
  expect_true(file.exists(renamed))

  expect_equal(nrow(dm), 2)
  expect_equal(dm$src_img, png_url)
  expect_equal(basename(dm$dest_img), basename(c(outs[1], renamed)))
})
