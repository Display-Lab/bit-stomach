library(testthat)
context('Test Internal Count Data Example')

pkg <- "bitstomach"
# system.file("example", "count", "config.yml", package = pkg, mustWork = T)

lib_path <- system.file(package = pkg, mustWork = T)
## Turn "." to lib_path#".", "inst", 
exp_path <- file.path(lib_path, "example", "count") 

req_fn <- c(
  spek_path       = "spek.json",
  config_path     = "config.yml",
  annotation_path = "annotations.r",
  data_path       = "performer-data.csv")

det_fp <- list.files(exp_path, full.names = T)
det_fn <- sub(pattern = ".*/", replacement = "", det_fp)

test_that('Detecting if all "Count" example files are detected.', {
  for (rf in req_fn) {
    expect_true(rf %in% det_fn, label = paste(rf, "was not detected."))
  }
})

file_idx <- na.omit(match(req_fn, det_fn))
exp_fp_l <- as.list(setNames(det_fp[file_idx], names(req_fn)))

test_that('Program runs with internal sample project.', {
  # config_path      <- system.file(ex_cnt_path, "config.yml", 
  #                                 package = pkg, mustWork = T)
  # spek_path        <- system.file(ex_cnt_path, "spek.json", 
  #                                 package = pkg, mustWork = T)
  # data_path        <- system.file(ex_cnt_path, "performer-data.csv", 
  #                                 package = pkg, mustWork = T)
  # annotation_path  <- system.file(ex_cnt_path, "annotations.r", 
  #                                 package = pkg, mustWork = T)
  # result <- bitstomach::main(spek_path = spek_path, 
  #                            config_path = config_path, 
  #                            annotation_path = annotation_path, 
  #                            data_path = data_path)
  
  CALL <- as.call(append(exp_fp_l, values = quote(bitstomach::main), after = 0))
  result <- eval(CALL)
  expect_type(result, 'character')
  expect_true(file.exists(result))
})
