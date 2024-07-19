test_that("Report for local", {
  skip_on_cran()

  test_f <- res_example
  # Full
  expect_snapshot(show_report(test_f))

  # Single bad
  expect_snapshot(show_report(res_example[2, ]))

  # Two bads
  expect_snapshot(show_report(res_example[c(2, 4), ]))

  # Single good
  expect_snapshot(show_report(res_example[1, ]))

  # Two goods
  expect_snapshot(show_report(res_example[-c(2, 4), ]))
})

test_that("Report for url", {
  skip_on_cran()

  test_f <- res_example
  # Full
  expect_snapshot(show_report(test_f, "url"))

  # Single bad
  expect_snapshot(show_report(res_example[2, ], "url"))

  # Two bads
  expect_snapshot(show_report(res_example[c(2, 4), ], "url"))

  # Single good
  expect_snapshot(show_report(res_example[1, ], "url"))

  # Two goods
  expect_snapshot(show_report(res_example[-c(2, 4), ], "url"))
})
