context('Canonicalize IDs')

TEST_DATA <- tibble::tribble(
    ~id, ~date, ~performance,
    "Alice", "2019-03-14", 9001,
    "Bob",   "2019-03-14", 100,
    "Carol", "2019-03-14", 10
  )

test_that('Does not modify data if id list is empty or null', {
  results_from_empty <- canonicalize_ids(data=TEST_DATA, id_cols=list())
  results_from_null  <- canonicalize_ids(data=TEST_DATA, id_cols=list())

  expect_identical(results_from_empty, TEST_DATA)
  expect_identical(results_from_null, TEST_DATA)

})
