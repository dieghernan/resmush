test_that("jpg", {
  skip_on_cran()
  skip_if_offline()

  # jpg
  url <- paste0(
    "https://raw.githubusercontent.com/dieghernan/resmush/main/",
    "img/sample-jpg-1mb.jpg"
  )

  loc_file <- download_to_temp(url)

  expect_silent(dm <- resmush_file(loc_file, report = FALSE))

  expect_equal(tools::file_ext(dm$dest_img), "jpg")

  unlink(c(dm$dest_img, dm$src_img), force = TRUE)

  # jpeg, has space
  url <- paste0(
    "https://raw.githubusercontent.com/dieghernan/resmush/main/",
    "img/sample-jpeg-1mb .jpeg"
  )
  loc_file <- download_to_temp(url)

  expect_silent(dm <- resmush_file(loc_file, report = FALSE))

  expect_true(file.exists(dm$src_img))
  expect_true(file.exists(dm$dest_img))
  expect_true(dm$notes == "OK")

  unlink(c(dm$dest_img, dm$src_img), force = TRUE)
})

test_that("gif", {
  skip_on_cran()
  skip_if_offline()

  # gif
  url <- paste0(
    "https://raw.githubusercontent.com/dieghernan/resmush/main/",
    "img/sample-gif-350kb.gif"
  )

  loc_file <- download_to_temp(url)

  expect_silent(dm <- resmush_file(loc_file, report = FALSE))

  expect_true(file.exists(dm$src_img))
  expect_true(file.exists(dm$dest_img))
  expect_true(dm$notes == "OK")
  unlink(c(dm$dest_img, dm$src_img), force = TRUE)
})


test_that("bmp", {
  skip_on_cran()
  skip_if_offline()

  # bmp
  url <- paste0(
    "https://raw.githubusercontent.com/dieghernan/resmush/main/",
    "img/sample-bmp-798kb.bmp"
  )

  loc_file <- download_to_temp(url)

  expect_silent(dm <- resmush_file(loc_file, report = FALSE))

  expect_true(file.exists(dm$src_img))
  expect_true(file.exists(dm$dest_img))
  expect_true(dm$notes == "OK")
  unlink(c(dm$dest_img, dm$src_img), force = TRUE)
})

test_that("tif", {
  skip_on_cran()
  skip_if_offline()

  # tiff
  url <- paste0(
    "https://raw.githubusercontent.com/dieghernan/resmush/main/",
    "img/sample-tiff-1mb.tiff"
  )

  loc_file <- download_to_temp(url)

  expect_silent(dm <- resmush_file(loc_file, report = FALSE))

  expect_true(file.exists(dm$src_img))
  expect_true(file.exists(dm$dest_img))
  expect_true(dm$notes == "OK")
  unlink(c(dm$dest_img, dm$src_img), force = TRUE)
})
