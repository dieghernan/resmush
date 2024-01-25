test_that("Message when no files", {
  png_file <- system.file("extimg/example.png", package = "resmush")

  # Copy to a temporary file with a given suffix
  suffix <- "_nonstandard"
  dir_temp <- file.path(tempdir(), "test_dir_nomess")
  tmp_png <- file.path(dir_temp, paste0("example", suffix, ".png"))

  if (!dir.exists(dir_temp)) dir.create(dir_temp)

  expect_true(file.copy(png_file, tmp_png, overwrite = TRUE))

  # Message
  expect_message(
    resmush_clean_dir(dir_temp),
    "No files to clean in"
  )


  unlink(dir_temp, force = TRUE, recursive = TRUE)
})


test_that("Message with 1 file", {
  png_file <- system.file("extimg/example.png", package = "resmush")

  # Copy to a temporary file with a given suffix
  suffix <- "_resmush"
  dir_temp <- file.path(tempdir(), "test_dir_onefile")
  tmp_png <- file.path(dir_temp, paste0("example", suffix, ".png"))

  if (!dir.exists(dir_temp)) dir.create(dir_temp)

  expect_true(file.copy(png_file, tmp_png, overwrite = TRUE))

  # Message
  expect_message(
    resmush_clean_dir(dir_temp),
    "Would remove 1 file"
  )


  unlink(dir_temp, force = TRUE, recursive = TRUE)
})

test_that("Message with 2 files", {
  png_file <- system.file("extimg/example.png", package = "resmush")

  # Copy to a temporary file with a given suffix
  suffix <- "_resmush"
  dir_temp <- file.path(tempdir(), "test_dir_twofile")
  tmp_png <- file.path(dir_temp, paste0("example", suffix, ".png"))
  tmp_png2 <- file.path(dir_temp, paste0("example2", suffix, ".png"))

  if (!dir.exists(dir_temp)) dir.create(dir_temp)

  expect_true(file.copy(png_file, tmp_png, overwrite = TRUE))
  expect_true(file.copy(png_file, tmp_png2, overwrite = TRUE))

  # Message
  expect_message(
    resmush_clean_dir(dir_temp),
    "Would remove 2 files"
  )


  unlink(dir_temp, force = TRUE, recursive = TRUE)
})
