context('Smoke Test Main')

test_that('Program runs with internal example project.', {
  spek_path        <- system.file("example", "spek.json", package="bitstomach", mustWork = T)
  data_path        <- system.file("example", "performer-data.csv", package="bitstomach", mustWork = T)
  annotation_path  <- system.file("example", "annotations.r", package="bitstomach", mustWork = T)

  result <- capture.output(main(spek_path, annotation_path=annotation_path, data_path=data_path))

  expect_type(result, 'character')
})

test_that('Runs with data and spek provided.', {
  skip("See issue-12")
  result <- capture.output(bitstomach::main())
  expect_type(result, 'character')
})

test_that('Provides useful error when data or spek is missing.', {
  skip("See issue-12")
})

