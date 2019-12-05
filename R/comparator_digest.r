#' @title Comparator Digest
#' @description Generate annotations about a single measure.
#' @param data a single measure's data; essentially measure_data[[n]].
#' @param spek Lists representation of spek graph
#' @param anno_env Environment containing annotation functions
comparator_digest <- function(comparator, data, spek, anno_env){
  dispositions_tbl <- generate_dispositions(data, anno_env, spek)
  # Update dispositions regarding measure
  old_disps <- dispositions_tbl[[BS$HAS_DISPOSITION_URI]]
  updated_disps <- lapply(old_disps, add_comparator_to_dispositions, m_id=measure_id)
  dispositions_tbl[[BS$HAS_DISPOSITION_URI]] <- updated_disps
  dispositions_tbl
}

#' @title Add Comparator to Disposition
#' @description Create structure relating dispositions to a measure
#' @param disposition List dispostion IRIs of the performer each the IRI of a class of information content entity
#' @param m_id The @id of the measure
#' @return List of updated dispositions.
add_comparator_to_dispositions <- function(dispositions, m_id){
  lapply(dispositions, attach_comparator, m = m_id)
}

#' @title Attach Comparator
#' @description Add regarding comparator predicate to a disposition
#' @return List measure with predicate associating comparator id added.
attach_comparator <- function(disp, m_id){
  disp[BS$REGARDING_COMPARATOR] <- list(list(`@id` = m_id))
  return(disp)
}
