test_that("Testing regex", {
  skip_on_cran()
  skip_if_offline()

  # Create a temp dir
  dir_temp <- file.path(tempdir(), "test1")
  if (!dir.exists(dir_temp)) dir.create(dir_temp)


  # tempfile not right extension
  fl <- file.path(dir_temp, "aa.txt")
  writeLines("testing a fake file", con = fl)
  expect_true(file.exists(fl))

  # Move one that exists
  file.copy(system.file("extimg/example.png", package = "resmush"),
    dir_temp,
    overwrite = TRUE
  )


  png_ok <- file.path(dir_temp, "example.png")

  expect_true(all(file.exists(fl, png_ok)))


  resmush_clean_dir(dir_temp)
  # Only one
  expect_silent(dm <- resmush_dir(dir_temp, ext = "png$"))

  expect_s3_class(dm, "data.frame")
  expect_equal(dm$src_img, png_ok)
  expect_equal(basename(dm$dest_img), "example_resmush.png")

  unlink(dir_temp, force = TRUE, recursive = TRUE)
})

test_that("Testing regex several with suffix", {
  skip_on_cran()
  skip_if_offline()

  # Create a temp dir
  dir_temp <- file.path(tempdir(), "test2")
  if (!dir.exists(dir_temp)) dir.create(dir_temp)


  # tempfile not right extension
  fl <- file.path(dir_temp, "aa.txt")
  writeLines("testing a fake file", con = fl)
  expect_true(file.exists(fl))

  # Move one that exists
  file.copy(system.file("extimg/example.png", package = "resmush"),
    dir_temp,
    overwrite = TRUE
  )


  png_ok <- file.path(dir_temp, "example.png")

  expect_true(all(file.exists(fl, png_ok)))


  resmush_clean_dir(dir_temp, "_some_error")
  # All ext
  expect_message(
    dm <- resmush_dir(dir_temp,
      ext = "*",
      suffix = "_some_error"
    ),
    "API Error"
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

  # Create a temp dir
  dir_temp <- file.path(tempdir(), "test3")
  if (!dir.exists(dir_temp)) dir.create(dir_temp)

  nested_dir <- file.path(dir_temp, "nested")

  if (!dir.exists(nested_dir)) dir.create(nested_dir)

  expect_length(list.dirs(dir_temp), 2)

  # Move one file
  file.copy(system.file("extimg/example.png", package = "resmush"),
    dir_temp,
    overwrite = TRUE
  )


  # Move more files
  file.copy(system.file("extimg/example.png", package = "resmush"),
    nested_dir,
    overwrite = TRUE
  )

  file.copy(system.file("extimg/example.jpg", package = "resmush"),
    nested_dir,
    overwrite = TRUE
  )


  png_top <- file.path(dir_temp, "example.png")
  png_nested <- file.path(nested_dir, "example.png")
  jpg_nested <- file.path(nested_dir, "example.jpg")

  expect_true(all(file.exists(png_top, png_nested, jpg_nested)))


  resmush_clean_dir(dir_temp, "_resmush", recursive = TRUE)

  expect_length(
    list.files(dir_temp, recursive = TRUE, pattern = "\\.(png|jpg)$"),
    3
  )

  # All ext
  expect_silent(dm <- resmush_dir(dir = c(dir_temp, nested_dir)))

  expect_s3_class(dm, "data.frame")
  expect_equal(nrow(dm), 3)

  expect_equal(
    basename(dm$src_img),
    c("example.png", "example.jpg", "example.png")
  )
  expect_equal(
    basename(dm$dest_img),
    add_suffix(c("example.png", "example.jpg", "example.png"))
  )

  # total files should be 6
  expect_length(
    list.files(
      path = c(dir_temp, nested_dir), full.names = TRUE,
      pattern = "\\.(png|jpg)$"
    ),
    6
  )

  unlink(dir_temp, force = TRUE, recursive = TRUE)
})


test_that("Testing separated dirs", {
  skip_on_cran()
  skip_if_offline()

  # Create a temp dir
  dir_temp <- file.path(tempdir(), "test4")
  if (!dir.exists(dir_temp)) dir.create(dir_temp)

  dir_temp2 <- file.path(tempdir(), "test5")

  if (!dir.exists(dir_temp2)) dir.create(dir_temp2)

  expect_length(list.dirs(c(dir_temp, dir_temp2)), 2)

  # Move one file
  file.copy(system.file("extimg/example.png", package = "resmush"),
    dir_temp,
    overwrite = TRUE
  )


  # Move more files
  file.copy(system.file("extimg/example.png", package = "resmush"),
    dir_temp2,
    overwrite = TRUE
  )

  file.copy(system.file("extimg/example.jpg", package = "resmush"),
    dir_temp2,
    overwrite = TRUE
  )


  png_top <- file.path(dir_temp, "example.png")
  png_top2 <- file.path(dir_temp2, "example.png")
  jpg_top2 <- file.path(dir_temp2, "example.jpg")

  expect_true(all(file.exists(png_top, png_top2, jpg_top2)))


  expect_length(
    list.files(c(dir_temp, dir_temp2),
      recursive = TRUE,
      pattern = "\\.(png|jpg)$"
    ),
    3
  )

  # All ext with overwrite
  expect_message(dm <- resmush_dir(
    dir = c(dir_temp, dir_temp2),
    suffix = "",
    verbose = TRUE, qlty = 10
  ))

  expect_s3_class(dm, "data.frame")
  expect_equal(nrow(dm), 3)

  expect_equal(
    basename(dm$src_img),
    c("example.png", "example.jpg", "example.png")
  )
  expect_equal(
    basename(dm$dest_img),
    c("example.png", "example.jpg", "example.png")
  )

  # total files should be 3 since we overwrite
  expect_length(
    list.files(
      path = c(dir_temp, dir_temp2), full.names = TRUE,
      pattern = "\\.(png|jpg)$"
    ),
    3
  )

  unlink(c(dir_temp, dir_temp2), force = TRUE, recursive = TRUE)
})
