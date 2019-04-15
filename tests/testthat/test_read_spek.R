context('read spek')

test_that('Provides default spek if not is provided.', {
  result <- suppressWarnings( read_spek() )
  expect_type(result, "list")
})

test_that('Provides warning when spek is missing.', {
  expect_warning( read_spek(), regexp = BS$WARN_NO_SPEK, fixed=T)
})
