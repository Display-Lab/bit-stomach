context("Reading Data")

test_that("Non-extant data file throws error.",{
  expect_error(read_data('bad/path/to/data.csv'))
})
