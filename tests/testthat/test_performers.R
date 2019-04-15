context("Performers from distilled annotations")

test_that("NULL annotions yield an empty data.frame",{

  result <- performers(NULL, "http://example.com/app")
  expect_s3_class(result, "data.frame")
  expect_equal(nrow(result), 0)
})
