test_that("Test no file", {
  dir_temp <- file.path(tempdir(), "resmush_test")
  a <- list.files(dir_temp, pattern = "I am a test")

  expect_length(a, 0)
  expect_snapshot(dm <- resmush_dir(a))
  expect_null(dm)
  unlink(dir_temp, recursive = FALSE, force = TRUE)
})

test_that("Testing regex", {
  skip_on_cran()
  skip_if_offline()

  # Create a temp dir
  dir_temp <- load_dir_to_temp()

  expect_length(list.files(dir_temp, pattern = "\\."), 2)

  resmush_clean_dir(dir_temp)
  # Only one
  expect_message(
    dm <- resmush_dir(dir_temp, ext = "png$"),
    "Resmushing 1 file"
  )

  expect_s3_class(dm, "data.frame")
  expect_equal(basename(dm$dest_img), "example_resmush.png")

  dir_temp <- gsub(basename(dir_temp), "", dir_temp)

  unlink(dir_temp, force = TRUE, recursive = TRUE)
})

test_that("Testing regex several with suffix", {
  skip_on_cran()
  skip_if_offline()

  # Create a temp dir
  dir_temp <- file.path(tempdir(), "test2")
  if (!dir.exists(dir_temp)) {
    dir.create(dir_temp)
  }

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

  expect_true(all(file.exists(fl, png_ok)))

  resmush_clean_dir(dir_temp, "_some_error")
  # All ext
  expect_message(
    dm <- resmush_dir(dir_temp, ext = "*", suffix = "_some_error")
  )

  expect_s3_class(dm, "data.frame")
  expect_equal(nrow(dm), 2)

  expect_equal(basename(dm$src_img), basename(c(fl, png_ok)))
  expect_equal(basename(dm$dest_img), c(NA, "example_some_error.png"))

  unlink(dir_temp, force = TRUE, recursive = TRUE)
})


test_that("Testing nested dirs", {
  skip_on_cran()
  skip_if_offline()

  dir_temp <- load_dir_to_temp()

  nested <- file.path(dir_temp, "top1")

  resmush_clean_dir(nested, "_resmush", recursive = TRUE)

  expect_length(
    list.files(nested, recursive = TRUE, pattern = "\\.(png|jpg)$"),
    2
  )

  # All ext recursive
  expect_message(
    dm <- resmush_dir(nested, recursive = TRUE),
    "Resmushing 2 files"
  )

  expect_s3_class(dm, "data.frame")
  expect_equal(nrow(dm), 2)

  expect_equal(
    basename(dm$src_img),
    c("sample_nested.jpg", "sample_top1.png")
  )
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
  expect_message(
    resmush_clean_dir(nested, "_resmush", recursive = TRUE),
    "Would remove 2 files"
  )

  expect_message(
    dm <- resmush_dir(nested, recursive = FALSE),
    "Resmushing 1 file"
  )

  expect_equal(nrow(dm), 1)
  unlink(dir_temp, force = TRUE, recursive = TRUE)
})


test_that("Testing separated dirs", {
  skip_on_cran()
  skip_if_offline()

  dir_temp <- load_dir_to_temp()

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
    "Resmushing 3 files"
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


test_that("Overwrite ignore suffix", {
  skip_on_cran()
  skip_if_offline()

  dir_temp <- load_dir_to_temp()

  dir_temp1 <- file.path(dir_temp, "top1")
  nested_dir <- file.path(dir_temp1, "nested")

  l_init <- list.files(dir_temp1, recursive = TRUE, pattern = "\\.(png|jpg)$")
  expect_length(l_init, 2)

  # All , suffix and overwrite
  expect_message(
    dm <- resmush_dir(
      dir = c(dir_temp1, nested_dir),
      suffix = "_not_exist",
      overwrite = TRUE
    )
  )

  expect_s3_class(dm, "data.frame")
  expect_equal(nrow(dm), 2)

  expect_equal(
    basename(dm$src_img),
    c("sample_nested.jpg", "sample_top1.png")
  )
  expect_equal(
    basename(dm$dest_img),
    c("sample_nested.jpg", "sample_top1.png")
  )

  # total files should be 2 since be overwrite
  l_end <- list.files(dir_temp1, recursive = TRUE, pattern = "\\.(png|jpg)$")

  expect_length(l_end, 2)

  # No new files

  expect_identical(l_init, l_end)

  unlink(dir_temp, force = TRUE, recursive = TRUE)
})
