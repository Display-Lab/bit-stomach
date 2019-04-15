context('Smoke Test Main')

test_that('Program runs with internal example project.', {
  spek_path  <- system.file("example", "spek.json", package="bitstomach", mustWork = T)
  data_path  <- system.file("example", "performer-data.csv", package="bitstomach", mustWork = T)
  anno_path  <- system.file("example", "annotations.r", package="bitstomach", mustWork = T)

  result <- capture_output(main(spek_path, annotation_path=anno_path, data_path=data_path))

  expect_type(result, 'character')
})

test_that('Provides error when data is missing.', {
  spek_path  <- system.file("example", "spek.json", package="bitstomach", mustWork = T)
  anno_path  <- system.file("example", "annotations.r", package="bitstomach", mustWork = T)

  expect_error( capture_output(main(spek_path, annotation_path=anno_path)))
})

