# # Example of Working with vignette
# anno_env <- source_annotations('vignettes/bob/annotations.r')
# spek <- spekex::read_spek('vignettes/bob/spek.json')
# col_types <- spekex::cols_for_readr(spek)
# raw_data <- read_data('vignettes/bob/performance.csv', col_types)
#
# measure_data <- h_setup_measuure_data(spek, raw_data)
# dispositions <- h_single_measure_run(spek, anno_env, measure_data)

#' Harness setup measure data
#' Prepare list of data by measure
#' @export
h_setup_measure_data <- function(spek, raw_data){
  id_columns <- spekex::get_id_col_from_spek(spek)
  idd_data <- canonicalize_ids(raw_data, id_columns)
  measure_data <- split_by_measure(idd_data, spek)
  return(measure_data)
}

#' Harness single measure run
#' Run the annotations for a single measure
#' @param measure_idx index of measure in measure_data
#' @param measure_data list of measure data sets
#' @param anno_env sourced annotations
#' @param spek configuration
#' @importFrom dplyr first
#' @export
h_single_measure_run <- function(spek, anno_env, measure_data, measure_idx=NULL){
  if(is.null(measure_idx)){ measure_idx <- 1 }

  # get measure id
  measure_id <- names(measure_data)[[measure_idx]]
  # if measure has a comparator, use the first one.
  comparators_ids <- h_lookup_comparator_ids(measure_id, spek)
  comparator_id <- dplyr::first(comparators_ids)

  # Assisng measure id and comparator id of annotations environment
  anno_env$measure_id <- measure_id
  anno_env$comparator_id <- comparator_id

  data <- measure_data[[measure_idx]]
  dispositions <- generate_dispositions(data, anno_env, spek)

  return(dispositions)
}

#' Harness lookup comparator ids
#' Convenience method of getting the comparators of a measure
#' @export
h_lookup_comparator_ids <- function(measure_id, spek){
  measure <- spekex::lookup_measure(measure_id, spek)
  comparator_ids <- sapply(spekex::comparators_of_measure(measure), spekex::id_of_comparator)
  return(comparator_ids)
}

#' Setup Annotation Args
#' Put together calling arguments that would be passed to an annotation function.
#' @return an environment suitable for use with `attach` to then run annotation function line by line.
#' @export
h_setup_annotation_call_args <- function(spek, anno_env, measure_data, measure_idx=NULL){
  if(is.null(measure_idx)){ measure_idx <- 1 }

  # get measure id
  measure_id <- names(measure_data)[[measure_idx]]
  # if measure has a comparator, use the first one.
  comparators_ids <- h_lookup_comparator_ids(measure_id, spek)
  comparator_id <- dplyr::first(comparators_ids)

  # Assisng measure id and comparator id of annotations environment
  anno_env$measure_id <- measure_id
  anno_env$comparator_id <- comparator_id

  data <- measure_data[[measure_idx]]

  # Setup the cache of the anno_env
  setup_anno_cache(data, anno_env, spek)

  # Create calling environment from anno_env
  anno_call_env <- new.env(parent = anno_env)
  anno_call_env$spek <- spek
  anno_call_env$data <- data

  return(anno_call_env)
}
