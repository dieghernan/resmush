test_that("resmush_url() optimizes remote JPG images", {
  skip_on_cran()
  skip_if_offline()

  url <- paste0(
    "https://dieghernan.github.io/resmush/",
    "img/sample-jpg-1mb.jpg"
  )

  expect_silent(dm <- resmush_url(url, progress = FALSE, report = FALSE))
  withr::defer(unlink(dm$dest_img, force = TRUE))

  expect_s3_class(dm, "data.frame")
  expect_true(file.exists(dm$dest_img))
  expect_identical(tools::file_ext(dm$dest_img), "jpg")
  expect_identical(dm$notes, "OK")
})

test_that("resmush_url() preserves JPEG basenames containing spaces", {
  skip_on_cran()
  skip_if_offline()

  url <- paste0(
    "https://dieghernan.github.io/resmush/",
    "img/sample-jpeg-1mb .jpeg"
  )

  expect_silent(dm <- resmush_url(url, progress = FALSE, report = FALSE))
  withr::defer(unlink(dm$dest_img, force = TRUE))

  expect_s3_class(dm, "data.frame")
  expect_true(file.exists(dm$dest_img))
  expect_identical(basename(dm$dest_img), basename(url))
  expect_identical(dm$notes, "OK")
})

test_that("resmush_url() preserves EXIF metadata when requested", {
  skip_on_cran()
  skip_if_offline()

  url <- paste0(
    "https://dieghernan.github.io/resmush/",
    "img/sample-jpg-exif-876kb.jpg"
  )
  noexif <- withr::local_tempfile(fileext = "_noexif.jpg")
  yesexif <- withr::local_tempfile(fileext = "_yesexif.jpg")

  expect_silent(
    no_exif <- resmush_url(url, noexif, progress = FALSE, report = FALSE)
  )
  expect_silent(
    yes_exif <- resmush_url(
      url,
      yesexif,
      progress = FALSE,
      report = FALSE,
      exif_preserve = TRUE
    )
  )

  expect_identical(no_exif$notes, "OK")
  expect_identical(yes_exif$notes, "OK")
  expect_lt(file.size(noexif), file.size(yesexif))
})

test_that("resmush_url() optimizes remote PNG images", {
  skip_on_cran()
  skip_if_offline()

  url <- paste0(
    "https://dieghernan.github.io/resmush/",
    "img/sample-png-3mb.png"
  )

  expect_silent(dm <- resmush_url(url, progress = FALSE, report = FALSE))
  withr::defer(unlink(dm$dest_img, force = TRUE))

  expect_s3_class(dm, "data.frame")
  expect_true(file.exists(dm$dest_img))
  expect_identical(basename(dm$dest_img), basename(url))
  expect_identical(dm$notes, "OK")
})

test_that("resmush_url() reports size-limit errors for oversized PNG images", {
  skip_on_cran()
  skip_if_offline()

  url <- paste0(
    "https://dieghernan.github.io/resmush/",
    "img/sample-png-10mb.png"
  )

  expect_silent(dm <- resmush_url(url, progress = FALSE, report = FALSE))

  expect_s3_class(dm, "data.frame")
  expect_identical(
    dm$notes,
    "502: The uploaded file must be smaller than 5 MB."
  )
  expect_all_true(is.na(dm$dest_img))
})

test_that("resmush_url() optimizes remote GIF images", {
  skip_on_cran()
  skip_if_offline()

  url <- paste0(
    "https://dieghernan.github.io/resmush/",
    "img/sample-gif-350kb.gif"
  )

  expect_silent(dm <- resmush_url(url, progress = FALSE, report = FALSE))
  withr::defer(unlink(dm$dest_img, force = TRUE))

  expect_s3_class(dm, "data.frame")
  expect_true(file.exists(dm$dest_img))
  expect_identical(tools::file_ext(dm$dest_img), "gif")
  expect_identical(dm$notes, "OK")
})

test_that("resmush_url() optimizes remote BMP images", {
  skip_on_cran()
  skip_if_offline()

  url <- paste0(
    "https://dieghernan.github.io/resmush/",
    "img/sample-bmp-798kb.bmp"
  )

  expect_silent(dm <- resmush_url(url, progress = FALSE, report = FALSE))
  withr::defer(unlink(dm$dest_img, force = TRUE))

  expect_s3_class(dm, "data.frame")
  expect_true(file.exists(dm$dest_img))
  expect_identical(tools::file_ext(dm$dest_img), "bmp")
  expect_identical(dm$notes, "OK")
})

test_that("resmush_url() optimizes remote TIFF images", {
  skip_on_cran()
  skip_if_offline()

  url <- paste0(
    "https://dieghernan.github.io/resmush/",
    "img/sample-tiff-1mb.tiff"
  )

  expect_silent(dm <- resmush_url(url, progress = FALSE, report = FALSE))
  withr::defer(unlink(dm$dest_img, force = TRUE))

  expect_s3_class(dm, "data.frame")
  expect_true(file.exists(dm$dest_img))
  expect_identical(tools::file_ext(dm$dest_img), "tiff")
  expect_identical(dm$notes, "OK")
})

test_that("resmush_url() returns structured results for remote TIF images", {
  skip_on_cran()
  skip_if_offline()

  url <- paste0(
    "https://dieghernan.github.io/resmush/",
    "img/sample-tif-1mb.tif"
  )

  expect_silent(dm <- resmush_url(url, progress = FALSE, report = FALSE))
  destinations <- dm$dest_img[!is.na(dm$dest_img)]
  withr::defer(unlink(destinations, force = TRUE))

  expect_s3_class(dm, "data.frame")
  expect_identical(dm$src_img, url)
  expect_length(dm$notes, 1)
  expect_false(is.na(dm$notes))
})
