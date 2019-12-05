#' @title Multiple Digest
#' @description Generate annotations about a measure and all it's comparators.
#' @param ldata named list of a measure's data; essentially measure_data[n].
#' @param spek Lists representation of spek graph
#' @param anno_env Environment containing annotation functions
multiple_digest <- function(ldata, spek, anno_env){
  # Get measure_id from the list name make available in annotation environment
  measure_id <- names(ldata)
  anno_env$measure_id <- measure_id

  # strip list from around data
  data <- ldata[[1]]

  assertions <- list()
  assertions[BS$REGARDING_MEASURE] <- measure_id

  # If there are comparators, create digest for each comparator
  measure <- lookup_measure(measure_id, spek)
  comparator_ids <- sapply(comparators_of_measure(measure), id_of_comparator)

  if(length(comparator_ids) > 0){
    comp_disps <- lapply(comparator_ids, generate_dispositions_for_comparator,
                         data=data, anno_env=anno_env, spek=spek, measure_id=measure_id)
    result_dispositions <- lapply(comp_disps, apply_measure_to_disps_table, measure_id=measure_id)
  }else{
    perf_dispositions <- generate_dispositions(data, anno_env, spek)
    # Update dispositions column regarding measure
    old_disps <- perf_dispositions[[BS$HAS_DISPOSITION_URI]]
    updated_disps <- lapply(old_disps, add_measure_to_dispositions, m_id=measure_id)
    perf_dispositions[[BS$HAS_DISPOSITION_URI]] <- updated_disps
    result_dispositions <- list(perf_dispositions)
  }
  return(result_dispositions)
}

# TODO: Replace measure_digest with multiple_digest.
# TODO: Refactor out common code and make copacetic with comparator digest and measure digest support functions.
apply_measure_to_disps_table <- function(disps_tbl, measure_id){
  # Update dispositions column regarding measure
  old_disps <- disps_tbl[[BS$HAS_DISPOSITION_URI]]
  updated_disps <- lapply(old_disps, add_measure_to_dispositions, m_id=measure_id)
  disps_tbl[[BS$HAS_DISPOSITION_URI]] <- updated_disps
  disps_tbl
}

generate_dispositions_for_comparator <- function(comp_id, data, anno_env, spek, measure_id){
    perf_dispositions <- generate_dispositions(data, anno_env, spek)
    # Update dispositions column regarding comparator
    old_disps <- perf_dispositions[[BS$HAS_DISPOSITION_URI]]
    updated_disps <- lapply(old_disps, add_comparator_to_dispositions, m_id=comp_id)
    perf_dispositions[[BS$HAS_DISPOSITION_URI]] <- updated_disps
    perf_dispositions
}

