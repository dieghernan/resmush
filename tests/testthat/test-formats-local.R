test_that("resmush_file() optimizes local JPG images", {
  skip_on_cran()
  skip_if_offline()

  url <- paste0(
    "https://dieghernan.github.io/resmush/",
    "img/sample-jpg-1mb.jpg"
  )
  loc_file <- local_download(url)

  expect_silent(
    dm <- resmush_file(loc_file, progress = FALSE, report = FALSE)
  )
  withr::defer(unlink(dm$dest_img, force = TRUE))

  expect_s3_class(dm, "data.frame")
  expect_true(file.exists(dm$src_img))
  expect_true(file.exists(dm$dest_img))
  expect_identical(tools::file_ext(dm$dest_img), "jpg")
  expect_identical(dm$notes, "OK")
})

test_that("resmush_file() accepts JPEG filenames containing spaces", {
  skip_on_cran()
  skip_if_offline()

  url <- paste0(
    "https://dieghernan.github.io/resmush/",
    "img/sample-jpeg-1mb .jpeg"
  )
  loc_file <- local_download(url)

  expect_silent(
    dm <- resmush_file(loc_file, progress = FALSE, report = FALSE)
  )
  withr::defer(unlink(dm$dest_img, force = TRUE))

  expect_s3_class(dm, "data.frame")
  expect_true(file.exists(dm$src_img))
  expect_true(file.exists(dm$dest_img))
  expect_identical(dm$notes, "OK")
})

test_that("resmush_file() optimizes local GIF images", {
  skip_on_cran()
  skip_if_offline()

  url <- paste0(
    "https://dieghernan.github.io/resmush/",
    "img/sample-gif-350kb.gif"
  )
  loc_file <- local_download(url)

  expect_silent(
    dm <- resmush_file(loc_file, progress = FALSE, report = FALSE)
  )
  withr::defer(unlink(dm$dest_img, force = TRUE))

  expect_s3_class(dm, "data.frame")
  expect_true(file.exists(dm$src_img))
  expect_true(file.exists(dm$dest_img))
  expect_identical(tools::file_ext(dm$dest_img), "gif")
  expect_identical(dm$notes, "OK")
})

test_that("resmush_file() optimizes local BMP images", {
  skip_on_cran()
  skip_if_offline()

  url <- paste0(
    "https://dieghernan.github.io/resmush/",
    "img/sample-bmp-798kb.bmp"
  )
  loc_file <- local_download(url)

  expect_silent(
    dm <- resmush_file(loc_file, progress = FALSE, report = FALSE)
  )
  withr::defer(unlink(dm$dest_img, force = TRUE))

  expect_s3_class(dm, "data.frame")
  expect_true(file.exists(dm$src_img))
  expect_true(file.exists(dm$dest_img))
  expect_identical(tools::file_ext(dm$dest_img), "bmp")
  expect_identical(dm$notes, "OK")
})

test_that("resmush_file() optimizes local TIFF images", {
  skip_on_cran()
  skip_if_offline()

  url <- paste0(
    "https://dieghernan.github.io/resmush/",
    "img/sample-tiff-1mb.tiff"
  )
  loc_file <- local_download(url)

  expect_silent(
    dm <- resmush_file(loc_file, progress = FALSE, report = FALSE)
  )
  withr::defer(unlink(dm$dest_img, force = TRUE))

  expect_s3_class(dm, "data.frame")
  expect_true(file.exists(dm$src_img))
  expect_true(file.exists(dm$dest_img))
  expect_identical(tools::file_ext(dm$dest_img), "tiff")
  expect_identical(dm$notes, "OK")
})
