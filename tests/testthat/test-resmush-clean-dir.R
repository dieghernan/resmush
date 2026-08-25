test_that("resmush_clean_dir() leaves directories unchanged without matches", {
  png_file <- system.file("extimg/example.png", package = "resmush")

  # Copy to a temporary file with a given suffix
  suffix <- "_nonstandard"
  dir_temp <- withr::local_tempdir(pattern = "test_dir_nomess")
  tmp_png <- file.path(dir_temp, paste0("example", suffix, ".png"))

  if (!dir.exists(dir_temp)) {
    dir.create(dir_temp)
  }

  expect_true(file.copy(png_file, tmp_png, overwrite = TRUE))

  # Message
  expect_snapshot(resmush_clean_dir(dir_temp), transform = scrub_snapshot_paths)
  expect_true(file.exists(tmp_png))
})

test_that("resmush_clean_dir() removes one matching file", {
  png_file <- system.file("extimg/example.png", package = "resmush")

  # Copy to a temporary file with a given suffix
  suffix <- "_resmush"
  dir_temp <- withr::local_tempdir(pattern = "test_dir_onefile")
  tmp_png <- file.path(dir_temp, paste0("example", suffix, ".png"))

  if (!dir.exists(dir_temp)) {
    dir.create(dir_temp)
  }

  expect_true(file.copy(png_file, tmp_png, overwrite = TRUE))

  # Message
  expect_snapshot(resmush_clean_dir(dir_temp), transform = scrub_snapshot_paths)
  expect_false(file.exists(tmp_png))
})

test_that("resmush_clean_dir() removes multiple matching files", {
  png_file <- system.file("extimg/example.png", package = "resmush")

  # Copy to a temporary file with a given suffix
  suffix <- "_resmush"
  dir_temp <- withr::local_tempdir(pattern = "test_dir_twofile")
  tmp_png <- file.path(dir_temp, paste0("example", suffix, ".png"))
  tmp_png2 <- file.path(dir_temp, paste0("example2", suffix, ".png"))

  if (!dir.exists(dir_temp)) {
    dir.create(dir_temp)
  }

  expect_true(file.copy(png_file, tmp_png, overwrite = TRUE))
  expect_true(file.copy(png_file, tmp_png2, overwrite = TRUE))

  # Message
  expect_snapshot(resmush_clean_dir(dir_temp), transform = scrub_snapshot_paths)
  expect_false(file.exists(tmp_png))
  expect_false(file.exists(tmp_png2))
})
