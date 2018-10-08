context('Test Build Configuration and Overrides')

test_that('Default config is used when path to config is NULL.', {
  result <- build_configuration()
  expect_equal(result$app_onto_url, "http://example.com/app#")
})

test_that('Warning emitted when path to config unreadable.', {
  config_path <- file.path("not","a","valid","file")
  expect_warning( build_configuration(config_path) )
})

test_that('Config file overrides default config.', {
  config_path <- system.file("example","count","config.yml", package="bitstomach")
  result <- build_configuration(config_path)
  expect_equal(result$app_onto_url, "http://example.com/app#")
})

test_that('Dots override file and default configs.', {
  config_path <- system.file("example","count","config.yml", package="bitstomach")
  result <- build_configuration(config_path, app_onto_url="https://overridd.en/app/test#")
  expect_equal(result$app_onto_url, "https://overridd.en/app/test#")
})
