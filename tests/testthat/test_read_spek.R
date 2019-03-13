context('read spek')

test_that('Provides default spek if not is provided.', {
  result <- read_spek()

  expect_type(result, "list")
})
