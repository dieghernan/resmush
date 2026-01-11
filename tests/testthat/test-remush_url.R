test_that("Test offline", {
  skip_on_cran()

  png_url <- paste0(
    "https://raw.githubusercontent.com/",
    "dieghernan/resmush/main/inst/",
    "extimg/example.png"
  )

  # Options for testing
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
  skip_if_offline()

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

  unlink(file.path(tempdir(), basename(dm$src_img)))
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

  # Mock default output
  out_f <- file.path(tempdir(), basename(png_url))

  if (file.exists(out_f)) {
    unlink(out_f, force = TRUE)
  }

  # Recover options

  optsinit <- options()
  expect_false(
    isTRUE(optsinit$cli.progress_bar_style == "aaa")
  )
  options(
    cli.progress_bar_style = "aaa",
    cli.progress_show_after = 1000,
    cli.spinner = "ccc"
  )

  optinit2 <- options()

  expect_true(optinit2$cli.progress_bar_style == "aaa")

  expect_message(dm <- resmush_url(png_url))

  # Restored options
  expect_identical(options(), optinit2)

  options(
    cli.progress_bar_style = optsinit$cli.progress_bar_style,
    cli.progress_show_after = optsinit$cli.progress_show_after,
    cli.spinner = optsinit$cli.spinner
  )

  expect_identical(options(), optsinit)

  expect_s3_class(dm, "data.frame")
  expect_false(any(is.na(dm)))
  expect_equal(dm$src_img, png_url)
  expect_equal(basename(dm$dest_img), basename(out_f))

  ratio <- as.double(gsub("%", "", dm$compress_ratio))
  expect_lt(ratio, 100)
  unlink(dm$dest_img, recursive = TRUE, force = TRUE)
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
    dm <- resmush_url(png_url, outf)
  )

  expect_true(file.exists(outf))
  expect_s3_class(dm, "data.frame")
  expect_false(any(is.na(dm)))
  expect_equal(dm$src_img, png_url)

  outs <- file.size(outf)

  # Check units
  fmrted <- make_pretty_size(outs)
  expect_identical(dm$dest_size, fmrted)
  unlink(dm$dest_img, recursive = TRUE, force = TRUE)
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
    dm <- resmush_url(jpg_url, outf)
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

  # Recover options

  optsinit <- options()
  expect_false(
    isTRUE(optsinit$cli.progress_bar_style == "aaa")
  )
  options(
    cli.progress_bar_style = "aaa",
    cli.progress_show_after = 1000,
    cli.spinner = "ccc"
  )

  optinit2 <- options()

  expect_true(optinit2$cli.progress_bar_style == "aaa")

  expect_silent(dm <- resmush_url(all_in, report = FALSE, progress = FALSE))

  # Restored options
  expect_identical(options(), optinit2)

  options(
    cli.progress_bar_style = optsinit$cli.progress_bar_style,
    cli.progress_show_after = optsinit$cli.progress_show_after,
    cli.spinner = optsinit$cli.spinner
  )
  expect_identical(options(), optsinit)

  expect_equal(nrow(dm), 4)
  expect_equal(dm$src_img, all_in)

  expect_equal(is.na(dm$dest_img), c(FALSE, TRUE, FALSE, TRUE))
  unlink(dm$dest_img, recursive = TRUE, force = TRUE)
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
  )

  expect_equal(nrow(dm), 4)
  expect_equal(dm$src_img, all_in)
  expect_equal(
    basename(dm$dest_img),
    basename(c(all_outs[1], NA, all_outs[3], NA))
  )

  expect_true(all(file.exists(all_outs[c(1, 3)])))

  unlink(dm$dest_img, recursive = TRUE, force = TRUE)
})


test_that("Handle duplicate names", {
  skip_on_cran()
  skip_if_offline()

  png_url_single <- paste0(
    "https://raw.githubusercontent.com/",
    "dieghernan/resmush/main/inst/",
    "extimg/example.png"
  )

  png_url <- rep(png_url_single, 3)

  outs <- file.path(tempdir(), basename(png_url))

  if (any(file.exists(outs))) {
    unlink(outs, force = TRUE)
  }

  expect_false(file.exists(outs[1]))

  # But should be renamed as
  renamed <- file.path(tempdir(), c("example_01.png", "example_02.png"))
  if (any(file.exists(renamed))) {
    unlink(renamed, force = TRUE)
  }
  expect_false(any(file.exists(renamed)))

  # Call
  expect_message(dm <- resmush_url(png_url, outs))

  # Check that now exists
  expect_true(all(file.exists(renamed)))

  expect_equal(nrow(dm), 3)
  expect_equal(dm$src_img, png_url)
  expect_equal(basename(dm$dest_img), basename(c(outs[1], renamed)))
  unlink(dm$dest_img, recursive = TRUE, force = TRUE)
})


test_that("Use  overwrite", {
  skip_on_cran()
  skip_if_offline()

  png_url_single <- paste0(
    "https://raw.githubusercontent.com/",
    "dieghernan/resmush/main/inst/",
    "extimg/example.png"
  )

  png_url <- rep(png_url_single, 3)

  outs <- file.path(tempdir(), "over", basename(png_url))
  the_dir <- unique(dirname(outs))

  if (any(file.exists(outs))) {
    unlink(outs, force = TRUE)
  }

  expect_false(file.exists(outs[1]))

  # Call with override
  expect_message(dm <- resmush_url(png_url, outs, overwrite = TRUE))

  expect_equal(nrow(dm), 3)
  expect_equal(dm$src_img, png_url)
  expect_equal(basename(dm$dest_img), basename(outs))

  # Check length, should be one
  ll <- list.files(the_dir, pattern = "png$")
  expect_length(ll, 1)
  expect_identical(ll, "example.png")

  unlink(the_dir, force = TRUE, recursive = TRUE)
})


test_that("To non-existing directories", {
  skip_on_cran()
  skip_if_offline()

  png_url <- paste0(
    "https://raw.githubusercontent.com/",
    "dieghernan/resmush/main/inst/",
    "extimg/example.png"
  )

  # Random folder name
  let1 <- paste0(LETTERS[sample(seq_len(20), 4, replace = TRUE)], collapse = "")
  let2 <- paste0(let1, "_", as.integer(runif(1) * 10))
  outf <- file.path(tempdir(), let1, let2)
  expect_false(dir.exists(outf))
  outs <- file.path(outf, basename(png_url))

  # Call
  expect_message(dm <- resmush_url(png_url, outs))

  # Check that now exists
  expect_true(dir.exists(outf))
  expect_true(file.exists(outs))

  # Clean up
  unlink(outf, force = TRUE, recursive = TRUE)
})

test_that("Test no file", {
  skip_on_cran()
  skip_if_offline()

  png_url <- paste0(
    "https://raw.githubusercontent.com/",
    "dieghernan/resmush/main/inst/",
    "extimg/example.png"
  )

  # Options for testing
  ops <- options()
  options(resmush_test_no_file = TRUE)

  expect_true("resmush_test_no_file" %in% names(options()))

  expect_snapshot(dm <- resmush_url(png_url))

  expect_null(dm)

  # Reset ops
  options(resmush_test_no_file = NULL)
  expect_false("resmush_test_no_file" %in% names(options()))
})
