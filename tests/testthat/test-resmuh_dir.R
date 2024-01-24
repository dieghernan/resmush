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


  dir_temp <- file.path(tempdir(), "test3")
  nested_dir <- file.path(dir_temp, "nested")

  png_top <- load_inst_to_temp("example.png", "test3")
  png_nested <- load_inst_to_temp("example.png", "test3/nested")
  jpg_nested <- load_inst_to_temp("example.jpg", "test3/nested")

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
  dir_temp2 <- file.path(tempdir(), "test5")

  expect_false(all(dir.exists(c(dir_temp, dir_temp2))))

  png_top <- load_inst_to_temp("example.png", "test4")
  png_top2 <- load_inst_to_temp("example.png", "test5")
  jpg_top2 <- load_inst_to_temp("example.jpg", "test5")

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


test_that("Overwrite ignore suffix", {
  skip_on_cran()
  skip_if_offline()

  skip_on_cran()
  skip_if_offline()


  dir_temp <- file.path(tempdir(), "test8")
  nested_dir <- file.path(dir_temp, "nested")

  png_top <- load_inst_to_temp("example.png", "test8")
  png_nested <- load_inst_to_temp("example.png", "test8/nested")
  jpg_nested <- load_inst_to_temp("example.jpg", "test8/nested")

  expect_true(all(file.exists(png_top, png_nested, jpg_nested)))


  l_init <- list.files(dir_temp, recursive = TRUE, pattern = "\\.(png|jpg)$")
  expect_length(l_init, 3)

  # All , suffix and overwrite
  expect_silent(dm <- resmush_dir(
    dir = c(dir_temp, nested_dir),
    suffix = "_not_exist",
    overwrite = TRUE
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

  # total files should be 3 since be overwrite
  l_end <- list.files(dir_temp, recursive = TRUE, pattern = "\\.(png|jpg)$")

  expect_length(l_end, 3)

  # No new files

  expect_identical(l_init, l_end)

  unlink(dir_temp, force = TRUE, recursive = TRUE)
})
