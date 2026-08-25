test_that("resmush_dir() returns NULL when no files match", {
  dir_temp <- withr::local_tempdir(pattern = "resmush_test")
  expect_length(list.files(dir_temp), 0)

  expect_snapshot(dm <- resmush_dir(dir_temp), transform = scrub_snapshot_paths)
  expect_null(dm)
})

test_that("resmush_dir() processes matching files from API results", {
  test_dir <- local_inst_dir()

  local_mocked_bindings(
    resmush_is_online = function() TRUE,
    smush_from_local = function(...) {
      list(dest = "https://example.com/optimized.png")
    },
    download_optimized_file = function(url, outfile, src, source_type) {
      file.copy(src, outfile, overwrite = TRUE)
      httr2::response(status_code = 200)
    }
  )

  expect_silent(dm <- resmush_dir(test_dir, progress = FALSE, report = FALSE))

  expect_s3_class(dm, "data.frame")
  expect_identical(basename(dm$src_img), c("example.jpg", "example.png"))
  expect_identical(
    basename(dm$dest_img),
    c("example_resmush.jpg", "example_resmush.png")
  )
  expect_all_true(file.exists(dm$dest_img))
  expect_all_equal(dm$compress_ratio, "0.00%")
  expect_all_equal(dm$notes, "OK")
})

test_that("resmush_dir() selects files with extension regular expressions", {
  skip_on_cran()
  skip_if_offline()

  # Create a temp dir
  dir_temp <- local_inst_dir()

  expect_length(list.files(dir_temp, pattern = "\\."), 2)

  resmush_clean_dir(dir_temp)
  # Only one
  suppressMessages(dm <- resmush_dir(dir_temp, ext = "png$"))

  expect_s3_class(dm, "data.frame")
  expect_equal(basename(dm$dest_img), "example_resmush.png")

  dir_temp <- gsub(basename(dir_temp), "", dir_temp)

  unlink(dir_temp, force = TRUE, recursive = TRUE)
})

test_that("resmush_dir() supports mixed extensions and custom suffixes", {
  skip_on_cran()
  skip_if_offline()

  # Create a temp dir
  dir_temp <- withr::local_tempdir(pattern = "test2")

  # tempfile not right extension
  fl <- file.path(dir_temp, "aa.txt")
  writeLines("testing a fake file", con = fl)
  expect_true(file.exists(fl))

  # Move one that exists
  file.copy(
    system.file("extimg/example.png", package = "resmush"),
    dir_temp,
    overwrite = TRUE
  )

  png_ok <- file.path(dir_temp, "example.png")

  expect_all_true(file.exists(c(fl, png_ok)))

  resmush_clean_dir(dir_temp, "_some_error")
  # All ext
  expect_message(
    dm <- resmush_dir(dir_temp, ext = "*", suffix = "_some_error"),
    "Failed to optimize 1 file"
  )

  expect_s3_class(dm, "data.frame")
  expect_equal(nrow(dm), 2)

  expect_equal(basename(dm$src_img), basename(c(fl, png_ok)))
  expect_equal(basename(dm$dest_img), c(NA, "example_some_error.png"))

  unlink(dir_temp, force = TRUE, recursive = TRUE)
})

test_that("resmush_dir() processes matching files recursively", {
  skip_on_cran()
  skip_if_offline()

  dir_temp <- local_inst_dir()

  nested <- file.path(dir_temp, "top1")

  resmush_clean_dir(nested, "_resmush", recursive = TRUE)

  expect_length(
    list.files(nested, recursive = TRUE, pattern = "\\.(png|jpg)$"),
    2
  )

  # All ext recursive
  expect_message(
    dm <- resmush_dir(nested, recursive = TRUE),
    "Saved results in directories"
  )

  expect_s3_class(dm, "data.frame")
  expect_equal(nrow(dm), 2)

  expect_equal(basename(dm$src_img), c("sample_nested.jpg", "sample_top1.png"))
  expect_equal(
    basename(dm$dest_img),
    add_suffix(c("sample_nested.jpg", "sample_top1.png"))
  )

  # total files should be 4
  expect_length(
    list.files(
      path = nested,
      full.names = TRUE,
      pattern = "\\.(png|jpg)$",
      recursive = TRUE
    ),
    4
  )

  # Now without recursive
  expect_snapshot(
    resmush_clean_dir(nested, "_resmush", recursive = TRUE),
    transform = scrub_snapshot_paths
  )

  expect_message(
    dm <- resmush_dir(nested, recursive = FALSE),
    "Saved result in directory"
  )

  expect_equal(nrow(dm), 1)
  unlink(dir_temp, force = TRUE, recursive = TRUE)
})

test_that("resmush_dir() combines results from multiple directories", {
  skip_on_cran()
  skip_if_offline()

  dir_temp <- local_inst_dir()

  # Create a temp dir
  dir_temp1 <- file.path(dir_temp, "top1")
  dir_temp2 <- file.path(dir_temp, "top2")

  expect_length(
    list.files(
      c(dir_temp1, dir_temp2),
      recursive = TRUE,
      pattern = "\\.(png|jpg)$"
    ),
    3
  )

  # All ext with overwrite
  expect_message(
    dm <- resmush_dir(
      dir = c(dir_temp1, dir_temp2),
      suffix = "",
      qlty = 10,
      recursive = TRUE
    ),
    "Saved results in directories"
  )

  expect_s3_class(dm, "data.frame")
  expect_equal(nrow(dm), 3)

  expect_equal(
    basename(dm$src_img),
    c("sample_nested.jpg", "sample_top1.png", "sample_top2.jpg")
  )
  expect_equal(
    basename(dm$dest_img),
    c("sample_nested.jpg", "sample_top1.png", "sample_top2.jpg")
  )

  # total files should be 3 since we overwrite
  expect_length(
    list.files(
      path = c(dir_temp1, dir_temp2),
      full.names = TRUE,
      pattern = "\\.(png|jpg)$",
      recursive = TRUE
    ),
    3
  )

  unlink(dir_temp, force = TRUE, recursive = TRUE)
})

test_that("resmush_dir() replaces source files when overwrite is enabled", {
  skip_on_cran()
  skip_if_offline()

  dir_temp <- local_inst_dir()

  dir_temp1 <- file.path(dir_temp, "top1")
  nested_dir <- file.path(dir_temp1, "nested")

  l_init <- list.files(dir_temp1, recursive = TRUE, pattern = "\\.(png|jpg)$")
  expect_length(l_init, 2)

  # Process all files with overwrite enabled.
  expect_message(
    dm <- resmush_dir(
      dir = c(dir_temp1, nested_dir),
      suffix = "_not_exist",
      overwrite = TRUE
    ),
    "Saved results in directories"
  )

  expect_s3_class(dm, "data.frame")
  expect_equal(nrow(dm), 2)

  expect_equal(basename(dm$src_img), c("sample_nested.jpg", "sample_top1.png"))
  expect_equal(basename(dm$dest_img), c("sample_nested.jpg", "sample_top1.png"))

  # The file count is unchanged because outputs overwrite inputs.
  l_end <- list.files(dir_temp1, recursive = TRUE, pattern = "\\.(png|jpg)$")

  expect_length(l_end, 2)

  # No new files are created.
  expect_identical(l_init, l_end)

  unlink(dir_temp, force = TRUE, recursive = TRUE)
})
