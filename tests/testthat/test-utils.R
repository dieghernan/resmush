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
    "./test.png",
    "./a./dot./test.png.jpg",
    "./test.jpg",
    "./test.jpg.png"
  )

  # Default behaviour
  def <- add_suffix(nodups)
  expect_identical(
    c(
      "./test_resmush.png",
      "./a./dot./test.png_resmush.jpg",
      "./test_resmush.jpg",
      "./test.jpg_resmush.png"
    ),
    def
  )

  same_res2 <- add_suffix(nodups, suffix = "_asuffix")
  expect_identical(
    c(
      "./test_asuffix.png",
      "./a./dot./test.png_asuffix.jpg",
      "./test_asuffix.jpg",
      "./test.jpg_asuffix.png"
    ),
    same_res2
  )
})

test_that("Response status descriptions are exposed", {
  resp <- httr2::response(status_code = 404)

  expect_identical(resmush_resp_status_desc(resp), "Not Found")
})

test_that("Snapshot scrubber masks temporary paths robustly", {
  temp_path <- gsub("\\", "/", tempdir(), fixed = TRUE)
  temp_path <- gsub("/+$", "", temp_path)
  split_temp_path <- sub("/", "//", temp_path, fixed = TRUE)

  scrubbed <- scrub_snapshot_paths(c(
    paste0("Saved in '", split_temp_path, "/resmush-dir-abc123'."),
    paste0("Saved in '", temp_path, "/working_dir/Rtmpabc123/ABCD/ABCD_1'."),
    "Remote URL: https://example.com/image.png"
  ))

  expect_identical(
    scrubbed,
    c(
      "Saved in '<tempdir>/resmush-dir-<id>'.",
      "Saved in '<tempdir>/<random-dir>'.",
      "Remote URL: https://example.com/image.png"
    )
  )
})
