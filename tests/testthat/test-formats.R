test_that("jpg", {
  skip_on_cran()
  skip_if_offline()

  # jpg
  url <- paste0(
    "https://raw.githubusercontent.com/dieghernan/resmush/main/",
    "img/sample-jpg-1mb.jpg"
  )


  expect_silent(dm <- resmush_url(url, report = FALSE))

  expect_equal(tools::file_ext(dm$dest_img), "jpg")

  unlink(dm$dest_img, force = TRUE)

  # jpeg, has space
  url <- paste0(
    "https://raw.githubusercontent.com/dieghernan/resmush/main/",
    "img/sample-jpeg-1mb .jpeg"
  )

  expect_silent(dm <- resmush_url(url, report = FALSE))
  expect_equal(basename(url), basename(dm$dest_img))

  unlink(dm$dest_img, force = TRUE)

  # Check exif online
  url <- paste0(
    "https://raw.githubusercontent.com/dieghernan/resmush/main/",
    "img/sample-jpg-exif-876kb.jpg"
  )

  noexif <- tempfile(fileext = "_noexif.jpg")

  no_exif <- resmush_url(url, noexif)


  yesexif <- tempfile(fileext = "_yesexif.jpg")

  yes_exif <- resmush_url(url, yesexif, exif_preserve = TRUE)


  expect_lt(file.size(noexif), file.size(yesexif))

  unlink(no_exif$dest_img, force = TRUE)
  unlink(yes_exif$dest_img, force = TRUE)
})


test_that("png", {
  skip_on_cran()
  skip_if_offline()

  # 3Mb
  url <- paste0(
    "https://raw.githubusercontent.com/dieghernan/resmush/main/",
    "img/sample-png-3mb.png"
  )


  expect_silent(dm <- resmush_url(url, report = FALSE))
  expect_true(file.exists(dm$dest_img))

  expect_equal(basename(url), basename(dm$dest_img))

  unlink(dm$dest_img, force = TRUE)

  # png more than 10 Mb
  url <- paste0(
    "https://raw.githubusercontent.com/dieghernan/resmush/main/",
    "img/sample-png-10mb.png"
  )

  expect_snapshot(dm <- resmush_url(url))

  expect_snapshot(dm[, -1])
})


test_that("gif", {
  skip_on_cran()
  skip_if_offline()

  # gif
  url <- paste0(
    "https://raw.githubusercontent.com/dieghernan/resmush/main/",
    "img/sample-gif-350kb.gif"
  )


  expect_silent(dm <- resmush_url(url, report = FALSE))
  unlink(dm$dest_img)
})


test_that("bmp", {
  skip_on_cran()
  skip_if_offline()

  # bmp
  url <- paste0(
    "https://raw.githubusercontent.com/dieghernan/resmush/main/",
    "img/sample-bmp-798kb.bmp"
  )


  dm <- resmush_url(url)
  expect_true(dm$notes == "OK")

  unlink(dm$dest_img)
})

test_that("tif", {
  skip_on_cran()
  skip_if_offline()

  # tiff
  url <- paste0(
    "https://raw.githubusercontent.com/dieghernan/resmush/main/",
    "img/sample-tiff-1mb.tiff"
  )


  expect_silent(dm <- resmush_url(url, report = FALSE))

  unlink(dm$dest_img, force = TRUE)

  # tif
  url <- paste0(
    "https://raw.githubusercontent.com/dieghernan/resmush/main/",
    "img/sample-tif-1mb.tif"
  )


  expect_snapshot(dm <- resmush_url(url))
})

test_that("webp", {
  skip_on_cran()
  skip_if_offline()

  # webp
  url <- paste0(
    "https://raw.githubusercontent.com/dieghernan/resmush/main/",
    "img/sample_webp_250kb.webp"
  )


  expect_silent(dm <- resmush_url(url, report = FALSE))

  expect_identical(basename(url), basename(dm$dest_img))

  unlink(dm$dest_img, force = TRUE)
})
