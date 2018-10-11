context('Smoke Test Main')

test_that('Runs with data and spek provided.', {
  skip("See issue-12")
  result <- capture.output(bitstomach::main())
  expect_type(result, 'character')
})

test_that('Provides useful error when data or spek is missing.', {
  skip("See issue-12")
})
