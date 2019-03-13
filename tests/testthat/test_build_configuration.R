context('Test Build Configuration and Overrides')

test_that('Default config from package constants is used when no parameters are given.', {
  result <- build_configuration()
  expect_equal(result, BS$DEFAULT_RUN_CONFIG)
})

test_that('Dots override file and default configs.', {
  result <- build_configuration(app_onto_url="https://overridd.en/app/test#")
  expect_equal(result$app_onto_url, "https://overridd.en/app/test#")
})
