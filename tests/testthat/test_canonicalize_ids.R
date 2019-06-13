context('Canonicalize IDs')

TEST_DATA <- tibble::tribble(
    ~fname , ~lname, ~idnum, ~date,        ~performance,
    "Alice", "Foo", 10,      "2019-03-14", 9001,
    "Bob",   "Bar", 20,      "2019-03-14", 100,
    "Carol", "Baz", 30,      "2019-03-14", 10
  )

test_that('Does not modify data if id list is empty or null', {
  results_from_empty <- canonicalize_ids(data=TEST_DATA, id_cols=list())
  results_from_null  <- canonicalize_ids(data=TEST_DATA, id_cols=list())

  expect_identical(results_from_empty, TEST_DATA)
  expect_identical(results_from_null, TEST_DATA)
})

test_that('Combines creates id column',{
  result <- canonicalize_ids(TEST_DATA, id_cols=list('fname','lname'))
  result_cnames <- colnames(result)

  expect_true( "id" %in% result_cnames)
})

test_that('Omits id_cols from result',{
  result <- canonicalize_ids(TEST_DATA, id_cols=list('fname','lname'))
  result_cnames <- colnames(result)

  expect_false( any(c("fname","lname") %in% result_cnames ))
})

test_that('Combines values from id_cols',{
  result <- canonicalize_ids(TEST_DATA, id_cols=list('fname','lname'))
  expected_ids <- c("Alice-Foo", "Bob-Bar", "Carol-Baz")

  expect_setequal(expected_ids, result$id)
})

test_that('List or vector of column names gives same result', {
  l_result <- canonicalize_ids(TEST_DATA, id_cols=list('fname','lname'))
  c_result <- canonicalize_ids(TEST_DATA, id_cols=c('fname','lname'))

  expect_identical(l_result, c_result)
})
