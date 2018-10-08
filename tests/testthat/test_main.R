context('Smoke Test Main')

test_that('Program runs with internal defaults.', {
  skip("update required")
  result <- bitstomach::main()
  expect_type(result, 'character')
  expect_true(file.exists(result))
})
