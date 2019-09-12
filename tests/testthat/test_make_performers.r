library('tibble')
library('rlang')
context('Test Make Performers')

M1_DISPOSITIONS <- list(list(list(`@type`=spekex::SE$POSITIVE_TREND_IRI, "http://example.com/slowmo#RegardingMeasure" = "_:m1"),
                             list(`@type`= spekex::SE$NEGATIVE_GAP_IRI,  "http://example.com/slowmo#RegardingMeasure" = "_:m1")),
                        list(list(`@type`=spekex::SE$POSITIVE_TREND_IRI, "http://example.com/slowmo#RegardingMeasure" = "_:m1")),
                        list(list(`@type`=spekex::SE$NEGATIVE_TREND_IRI, "http://example.com/slowmo#RegardingMeasure" = "_:m1"),
                             list(`@type`= spekex::SE$POSITIVE_GAP_IRI,  "http://example.com/slowmo#RegardingMeasure" = "_:m1")) )

M2_DISPOSITIONS <- list(list(list(`@type`=spekex::SE$NEGATIVE_TREND_IRI, "http://example.com/slowmo#RegardingMeasure" = "_:m2"),
                             list(`@type`=spekex::SE$POSITIVE_GAP_IRI,   "http://example.com/slowmo#RegardingMeasure" = "_:m2")),
                        list(list(`@type`=spekex::SE$POSITIVE_GAP_IRI,   "http://example.com/slowmo#RegardingMeasure" = "_:m2")),
                        list(list(`@type`=spekex::SE$NEGATIVE_GAP_IRI,   "http://example.com/slowmo#RegardingMeasure" = "_:m2")) )
IDS <- c("Alice", "Bob", "Carol")

M1_TABLE <- tibble( `@id`= IDS, !!BS$HAS_DISPOSITION_URI := M1_DISPOSITIONS )
M2_TABLE <- tibble( `@id`= IDS, !!BS$HAS_DISPOSITION_URI := M2_DISPOSITIONS )

test_that("Emits a data frame",{
  measure_dispositions <- list(M1_TABLE, M2_TABLE)
  result <- make_performers(measure_dispositions)
  expect_s3_class(result, 'data.frame')
})

test_that("Emits one row per performer",{
  measure_dispositions <- list(M1_TABLE, M2_TABLE)
  result <- make_performers(measure_dispositions)
  expect_equal(nrow(result), 3)
})

test_that("Ids are prefixed with blank node namespace", {
  measure_dispositions <- list(M1_TABLE, M2_TABLE)
  result <- make_performers(measure_dispositions)
  expect_setequal(result$`@id`, paste0("_:p",IDS) )
})

test_that("Type is added to performers", {
  measure_dispositions <- list(M1_TABLE, M2_TABLE)
  result <- make_performers(measure_dispositions)
  expect_true(all(result$`@type` == BS$PERFORMER_URI))
})

test_that("Regarding meaure predicate is preserved", {
  measure_dispositions <- list(M1_TABLE, M2_TABLE)
  result <- make_performers(measure_dispositions)
  dispos <- result[[1,2]]
  m_ids <- sapply(dispos, FUN=getElement, name=BS$REGARDING_MEASURE)
  expect_type(m_ids, "character")
  expect_false(any(is.null(m_ids)))
  expect_false(any(is.na(m_ids)))
})
