#' @title Read Data
#' @description Read data from path
#' @importFrom readr read_csv
read_data <- function(data_path, col_types=NULL) {
  readr::read_csv(data_path, col_types = col_types)
}
