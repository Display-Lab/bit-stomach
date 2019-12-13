context('Smoke Test Main')


# Expect success for a suite
run_suite <- function(suite_name){
  print(paste0("Run suite:", suite_name))
  spek_path <- spekex::get_spek_path(suite_name)
  data_path <- spekex::get_data_path(suite_name)
  anno_path <- spekex::get_annotations_path(suite_name)

  result <- capture_output(main(spek_path, annotation_path=anno_path, data_path=data_path))
}

# This is an integration test that takes a while. Use Sys.setenv("FULLTEST"=FALSE) to skip.
test_that('Program runs with all example projects.', {
  skip_if_not(Sys.getenv("FULLTEST") == TRUE, "Sys.getenv('FULLTEST')")
  suite_names <- spekex::list_suite_names()
  cat("\n")
  results <- lapply(suite_names, run_suite)

  expect_true(all(sapply(results, is.character)))
})

test_that('Program runs with sham example project.', {
  spek_path <- spekex::get_spek_path('sham')
  data_path <- spekex::get_data_path('sham')
  anno_path <- spekex::get_annotations_path('sham')

  result <- capture_output(main(spek_path, annotation_path=anno_path, data_path=data_path))

  expect_type(result, 'character')
})

test_that('Provides error when data is missing.', {
  spek_path  <- spekex::get_spek_path('sham')
  anno_path  <- spekex::get_annotations_path('sham')

  expect_error( capture_output(main(spek_path, annotation_path=anno_path)))
})

