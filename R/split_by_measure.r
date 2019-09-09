#' @title Split by Measure
#' @description Split canonicalized data
#' @param data data frame of performance data with id's already canonicalized.
#' @param spek Lists representation of spek
#' @importFrom spekex get_measure_colname
#' @return List of data frames each with a single measure
split_by_measure <- function(data, spek){
  measure_colname <- spekex::get_measure_colname(spek)
  if(is.na(measure_colname)){
    measure_ids <- sapply(spekex::measures_from_spek(spek), FUN=spekex::id_of_measure)
    list_name <- dplyr::first(measure_ids, default="null")
    measure_dfs <- list(data)
    names(measure_dfs) <- list_name
  } else {
    measure_vals <- data[,measure_colname]
    measure_dfs <- split(data, f=measure_vals)
    measure_ids  <- sapply(names(measure_dfs), FUN=spekex::lookup_measure_id, spek=spek)
    names(measure_dfs) <- measure_ids
  }

  return(measure_dfs)
}
