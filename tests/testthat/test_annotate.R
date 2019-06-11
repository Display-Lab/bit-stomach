library(tibble)
context('Test Annotation Environment Handling and Executing')

dummy_neg_gap_anno <- function(data, spek){
  data %>%
    group_by(id) %>%
    dplyr::filter(timepoint == max(timepoint)) %>%
    summarize(negative_gap=TRUE)
}

test_that('Warning emitted when no annotate functions are present.', {
  # A bad environment lacking an annotate function
  bad_env <- new.env()
  bad_env$foo <- function(){ }

  mock_data <- data.frame(foo=c(1,2,3), bar=c(1,2,3))

  spek <- list()

  expect_warning(
    annotate(mock_data, bad_env, spek),
    regexp=BS$WARN_NO_ANNOTATION_FUNCTIONS,
    fixed=TRUE
  )
})

test_that('Cache is added to annotation environment when setup_cache is present.',{
  mock_data <- data.frame(foo=c(1,2,3), bar=c(1,2,3))

  good_env <- new.env()
  good_env$annotate_bar <- function(data, spek){}
  good_env$setup_cache <- function(data, spek){ list(foo="bar")}

  annotate(mock_data, good_env, list())

  expect_identical(good_env$cache, list(foo="bar") )
})

test_that('Cache is absent from annotation environment when setup_cache is absent.',{
  mock_data <- data.frame(foo=c(1,2,3), bar=c(1,2,3))

  good_env <- new.env()
  good_env$annotate_bar <- function(data, spek){}

  annotate(mock_data, good_env, list())

  expect_null(good_env$cache)
})

test_that('Runs single annotate function in environment',{
  data <- data.frame()

  anno_env <- new.env()
  anno_env$annotate_has_gap <- function(data, spek){data.frame(id=c('a','b','c'), 'has_gap'=c(T,T,F))}
  result <- annotate(data, anno_env, spek=list())

  expect_identical(colnames(result), c('id','has_gap'))
})

test_that('Runs all annotate functions in environment',{
  data <- data.frame()

  anno_env <- new.env()
  anno_env$annotate_has_gap <- function(data, spek){data.frame(id=c('a','b','c'), 'has_gap'=c(T,T,F))}
  anno_env$annotate_has_trend <- function(data, spek){data.frame(id=c('a','b','c'), 'has_trend'=c(T,T,F))}
  result <- annotate(data, anno_env, spek=list())

  annotations_present_in_colnames <- c('has_gap','has_trend') %in% colnames(result)
  id_present_in_colnames <- 'id' %in% colnames(result)
  expect_true(all(annotations_present_in_colnames, id_present_in_colnames))
})

test_that('Emits error when error encountered in annotation functions.',{
  data <- data.frame()
  anno_env <- new.env()
  anno_env$annotate_error <- function(data, spek){stop("foo")}

  expect_error( annotate(data, anno_env, spek = list()) )
})

test_that('Emits single error containing all encountered error messages',{
  data <- data.frame()
  anno_env <- new.env()
  anno_env$annotate_error_one <- function(data, spek){stop("foo")}
  anno_env$annotate_error_two <- function(data, spek){stop("bar")}

  err <- capture_error( annotate(data, anno_env, list()))
  messages_found <- sapply(c('foo','bar'), grepl, x=err$message)

  expect_true(all(messages_found))
})
