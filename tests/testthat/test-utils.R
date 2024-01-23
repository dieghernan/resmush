test_that("Add suffix", {
  unique_names <- c("./a/example.png", "b/example.jpg")
  expect_length(unique(unique_names), 2)
  same_res <- add_suffix(unique_names, suffix = "")
  same_res_na <- add_suffix(unique_names, suffix = NA)
  same_res_null <- add_suffix(unique_names, suffix = NULL)
  expect_identical(unique_names, same_res)
  expect_identical(unique_names, same_res_na)
  expect_identical(unique_names, same_res_null)

  # More extensions with suffix
  nodups <- c(
    "./test.png", "./a./dot./test.png.jpg",
    "./test.jpg", "./test.jpg.png"
  )

  # Default behaviour
  def <- add_suffix(nodups)
  expect_identical(
    c(
      "./test_resmush.png", "./a./dot./test.png_resmush.jpg",
      "./test_resmush.jpg", "./test.jpg_resmush.png"
    ),
    def
  )

  same_res2 <- add_suffix(nodups, suffix = "_asuffix")
  expect_identical(
    c(
      "./test_asuffix.png", "./a./dot./test.png_asuffix.jpg",
      "./test_asuffix.jpg", "./test.jpg_asuffix.png"
    ),
    same_res2
  )
})
