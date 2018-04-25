context('Test Internal Count Data Example')

test_that('Program runs with internal sample project.', {
  config_path      <- system.file("example","count", "config.yml", package="bitstomach", mustWork = T)
  data_path        <- system.file("example","count", "performer-data.csv", package="bitstomach", mustWork = T)
  annotation_path  <- system.file("example","count", "annotations.r", package="bitstomach", mustWork = T)

  result <- bitstomach::main(config_path, annotation_path=annotation_path, data_path=data_path)

  expect_type(result, 'character')
  expect_true(file.exists(result))
})
