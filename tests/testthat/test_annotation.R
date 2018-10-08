# test env handling
context('Test Annotation Environment Handling and Executing')

# A bad environment lacking an annotate function
bad_env <- new.env()
bad_env$foo <- function(){ }

# A good environment with an annotate function
good_env <- new.env()
good_env$annotate_bar <- function(data, col_spec){}

# An ugly environment with an annotate function with mismatching arity
ugly_env <- new.env()
ugly_env$annotate_flub <- function(data){}

test_that('Program complains when no annotate functions are present.', {
  skip("todo")
  expect_success(expect_warning(
    annotate(mock_data, bad_env, col_spec),
    BS$NO_ANNOTATION_WARNING
  ))
})
