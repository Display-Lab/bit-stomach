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
  wrapped_measure_id <- list(list(`@id`=measure_id))

  if(length(comparator_ids) > 0){
    comp_disps <- lapply(comparator_ids, generate_dispositions_for_comparator,
                         data=data, anno_env=anno_env, spek=spek)
    result_disps <- lapply(comp_disps, append_to_dispositions,
                           predicate=BS$REGARDING_MEASURE, object=wrapped_measure_id)
  }else{
    dispositions <- generate_dispositions(data, anno_env, spek)
    dispositions <- append_to_dispositions(dispositions,
                                           predicate=BS$REGARDING_MEASURE,
                                           object=wrapped_comparator_id)
    result_disps <- list(dispositions)
  }
  return(result_disps)
}

#' @describeIn multiple_digest
#' @param comp_id id of comparator
#' @return list of disposition tables
generate_dispositions_for_comparator <- function(comp_id, data, anno_env, spek){
    anno_env$comparator_id <- comp_id
    dispositions <- generate_dispositions(data, anno_env, spek)
    # Update dispositions column regarding comparator
    wrapped_comparator_id <- list(list(`@id`=comp_id))
    dispositions <- append_to_dispositions(dispositions,
                                           predicate=BS$REGARDING_COMPARATOR,
                                           object=wrapped_comparator_id)
}
