library(tibble)
context("Aggregate distilled annotations")

DISPOSITIONS <- tibble::tribble(
~id     ,~disposition ,
"Alice" , list(`@type` = "http://purl.obolibrary.org/obo/psdo.owl/psdo_0000105"),
"Bob"   , list(`@type` = "http://purl.obolibrary.org/obo/psdo.owl/psdo_0000105"),
"Alice" , list(`@type` = "http://purl.obolibrary.org/obo/psdo.owl/psdo_0000100"),
"Bob"   , list(`@type` = "http://purl.obolibrary.org/obo/psdo.owl/psdo_0000099"),
"Carol" , list(`@type` = "http://purl.obolibrary.org/obo/psdo.owl/psdo_0000104"),
"Dan"   , list(`@type` = "http://purl.obolibrary.org/obo/psdo.owl/psdo_0000105")
)

ANNOTATIONS <- tibble::tribble(
~id     ,~negative_gap ,~positive_gap,
"Alice" ,FALSE         ,TRUE         ,
"Bob"   ,TRUE          ,FALSE        ,
"Carol" ,TRUE          ,TRUE         ,
"Dan"   ,FALSE         ,FALSE        )


test_that("NULL annotions yield an empty data.frame",{
  result <- aggregate_dispositions(NULL)
  expect_s3_class(result, "data.frame")
  expect_equal(nrow(result), 0)
})

test_that("Output column names are json-ld key values", {
  result <- aggregate_dispositions(DISPOSITIONS)
  expect_setequal(names(result), c('@id', BS$HAS_DISPOSITION_URI))
})

test_that("Aggregates ids to unique set",{
  num_unique_ids <- length(unique(DISPOSITIONS$id))

  result <- aggregate_dispositions(DISPOSITIONS)
  expect_equal(nrow(result), num_unique_ids)
})

test_that("Aggregated dispositions total same as input.", {
  result <- aggregate_dispositions(DISPOSITIONS)

  original_num_of_dispositions <- nrow(DISPOSITIONS)
  sum_of_aggregate_dispositions <- sum(sapply(result[[BS$HAS_DISPOSITION_URI]], length))

  expect_equal(original_num_of_dispositions, sum_of_aggregate_dispositions)
})

test_that("Performer's dispositions are wrapped into a list", {
  alices_dispositions <- DISPOSITIONS$disposition[DISPOSITIONS$id=="Alice"]

  result <- aggregate_dispositions(DISPOSITIONS)
  alices_result <- result[result$`@id` == "Alice",]
  alices_agg_dispositions <- alices_result[[BS$HAS_DISPOSITION_URI]]

  expect_type(alices_agg_dispositions, "list")
  expect_length(alices_agg_dispositions, 1)
  expect_setequal(alices_agg_dispositions[[1]], alices_dispositions)
})
