library(spekex)
context('Test split by measure')

VA2_SPEK <- spekex::read_spek(spekex::get_spek_path("va2"))
VA2_DATA <- read_data(spekex::get_data_path("va2"))

SHAM_SPEK <- spekex::read_spek(spekex::get_spek_path("sham"))
SHAM_DATA <- read_data(spekex::get_data_path("sham"))

test_that('Split by measure yields correct size list.', {
  result <- split_by_measure(VA2_DATA, VA2_SPEK)
  expect_equal(length(result), 2)
})

test_that('Split by measure yields list using measure ids as names.', {
  result <- split_by_measure(VA2_DATA, VA2_SPEK)
  # expect names begin with the expected spekex bnode naming prefix for measures
  pattern <- paste0("^", SE$MEASURE_BNODE_PREFIX)
  expect_match(names(result), pattern)
})

test_that('No measure column returns list with only original data', {
  result <- split_by_measure(SHAM_DATA, SHAM_SPEK)
  expect_identical(names(result), c("_:m1"))
  expect_equivalent(result[[1]], SHAM_DATA)
})


