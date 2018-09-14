context('Test Build Configuration and Overrides')

test_that('Default config is used when path to config is NULL.', {
  result <- bitstomach:::build_configuration()
  expect_equal(result$app_onto_url, "https://inference.es/app/onto#")
})

test_that('Warning emitted when path to config unreadable.', {
  config_path <- file.path("not","a","valid","file")
  expect_warning(bitstomach:::build_configuration(config_path) )
})

pkg <- "bitstomach"
test_that('Config file overrides default config.', {
  config_path <- system.file("example","count","config.yml", package = pkg)
  result <- bitstomach:::build_configuration(config_path)
  expect_equal(result$app_onto_url, "https://inference.es/app/count#")
})

test_that('Dots override file and default configs.', {
  config_path <- system.file("example","count","config.yml", package = pkg)
  turl <- "https://overridd.en/app/test#"
  result <- bitstomach:::build_configuration(config_path, app_onto_url = turl)
  expect_equal(result$app_onto_url, turl)
})
