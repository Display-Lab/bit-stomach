context("Swap in URIs")


test_that("NULL annotations yields NULL result", {
  expect_null(swap_in_uris(NULL, list("foo"="bar")))
})
