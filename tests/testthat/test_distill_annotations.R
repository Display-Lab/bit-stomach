context("Distilling annotations")


test_that("NULL annotations returns NULL.",{
  expect_null(distill_annotations(NULL))
})

test_that("Annotations require an id column.",{
  no_id_annotations <- data.frame(
    `persons` = c("Alice", "Bob"),
    `http://example.com/demo#disposition` = c(TRUE, FALSE)
  )

  expect_error(distill_annotations(no_id_annotations), regexp = BS$ERROR_NO_ID_COLUMN, fixed=TRUE)
})

test_that("Distilled annotations create row per disposition a performer has", {
  annotations <- data.frame(
    `id` = c("Alice", "Bob"),
    `http://example.com/demo#has_gap`   = c(TRUE, TRUE),
    `http://example.com/demo#has_trend` = c(TRUE, FALSE),
    `http://example.com/demo#small_gap` = c(FALSE, TRUE),
    `http://example.com/demo#big_gap`   = c(FALSE, TRUE)
  )

  result <- distill_annotations(annotations)

  # Four dispositions were true.  Expect four rows
  expect_equal(nrow(result), 5)

  # Expect Alice and Bob to one row per true disposition
  expect_equal( sum(result$id == 'Bob'), 3)
  expect_equal( sum(result$id == 'Alice'), 2)
})
