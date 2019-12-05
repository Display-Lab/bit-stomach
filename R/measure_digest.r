#' @title Measure Digest
#' @description Generate annotations about a single measure.
#' @param ldata named list of a single measure's data; essentially measure_data[n].
#' @param spek Lists representation of spek graph
#' @param anno_env Environment containing annotation functions
measure_digest <- function(ldata, spek, anno_env){
  data <- ldata[[1]]

  # Add measure_id to the annotation environment so it's accessible
  measure_id <- names(ldata)
  anno_env$measure_id <- measure_id

  measure <- lookup_measure(measure_id, spek)
  # Else run once anyway? or special no-comparator handling?
  perf_dispositions <- generate_dispositions(data, anno_env, spek)
  # Update dispositions column regarding measure
  old_disps <- perf_dispositions[[BS$HAS_DISPOSITION_URI]]
  updated_disps <- lapply(old_disps, add_measure_to_dispositions, m_id=measure_id)
  perf_dispositions[[BS$HAS_DISPOSITION_URI]] <- updated_disps

  # TODO: can probably return multiple lists of performer dispositions.
  # Wrap tibble in a list to fit return type of lmap
  return(list(perf_dispositions))
}


#' @title Add Measure to Disposition
#' @description Create structure relating dispositions to a measure
#' @param disposition List dispostion IRIs of the performer each the IRI of a class of information content entity
#' @param m_id The @id of the measure
#' @return List of updated dispositions.
add_measure_to_dispositions <- function(dispositions, m_id){
  lapply(dispositions, attach_measure, m = m_id)
}

#' @title Attach Measure
#' @description Add regarding measure predicate to a disposition
#' @return List measure with predicate associating measure id added.
attach_measure <- function(disp, m_id){
  disp[BS$REGARDING_MEASURE] <- list(list(`@id` = m_id))
  return(disp)
}

