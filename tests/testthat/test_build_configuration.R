context('Test Build Configuration and Overrides')

test_that('Default config from package constants is used when no parameters are given.', {
  result <- build_configuration()
  expect_identical(result, BS$DEFAULT_RUN_CONFIG)
})

test_that('Dots override file and default configs.', {
  result <- build_configuration(app_onto_url="https://overridd.en/app/test#")
  expect_equal(result$app_onto_url, "https://overridd.en/app/test#")
})

test_that('Default col_spec is all empty', {
  result <- build_configuration()
  empty_vals <- sapply(result$col_spec, function(x) is.list(x) && length(x) < 1)
  expect_true(all(empty_vals))
})

test_that('Build config reads col_spec from spek',{
  skip('issue 22')
})
