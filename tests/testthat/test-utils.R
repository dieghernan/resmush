test_that("Handle duplicate names", {
  unique_names <- c("./a/example.png", "b/example.jpg")
  expect_length(unique(unique_names), 2)


  same_res <- make_unique_paths(unique_names)

  expect_identical(unique_names, same_res)

  # More extensions
  nodups <- c("./test.png", "./test.png.jpg", "./test.jpg", "./test.jpg.png")

  same_res2 <- make_unique_paths(nodups)
  expect_identical(nodups, same_res2)

  # With duplicates

  complex <- c(
    "./a/example.png", "b/example.jpg", "cd/example.png",
    "ss/example.jpg", "ffaa/example.png",
    "a/a file with blak spaces.txt"
  )

  expect_false(length(unique(basename(complex))) == length(complex))

  handle_complex <- make_unique_paths(complex)

  expect_length(unique(basename(handle_complex)), length(handle_complex))


  expect_true(all((complex == handle_complex)[c(1, 2, 6)]))

  expect_identical(
    basename(handle_complex)[-c(1, 2, 6)],
    c("example_1.png", "example_1.jpg", "example_2.png")
  )
})
