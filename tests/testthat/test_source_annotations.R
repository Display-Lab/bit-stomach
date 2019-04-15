context('Sourcing annotations')


test_that("Environment with annotation functions are returned.",{
  anno_path <- system.file("example","annotations.r", package = "bitstomach")

  result <- source_annotations(anno_path)
  expect_type(result, "environment")

  names_begin_with_annotate <- grepl("^annotate", names(result))
  expect_true(any(names_begin_with_annotate))
})

test_that("Returns empty environment if path is missing.", {
  result <- source_annotations(NULL)
  expect_type(result, "environment")
  expect_identical(ls(result), character(0))
})

test_that("Emits error if path to environment is invalid.", {
  anno_path <- system.file("not","extant")
  expect_error(source_annotations(anno_path), regexp=BS$ERROR_INVALID_ANNOTATION_PATH, fixed=TRUE)
})
