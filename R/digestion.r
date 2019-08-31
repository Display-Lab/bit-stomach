#' @title Digestion
#' @description Digest the inputs specified in the runtime configuration.
#' @param annotation_path path to annotations.r file
#' @param raw_data data frame of performance data as read from disk
#' @param spek Lists representation of spek graph
#' @return table of performers and their annotations
#' @importFrom spekex get_id_col_from_spek
digestion <- function(annotation_path, raw_data, spek){
  # Source annotation functions and additional uri lookup
  anno_env <- source_annotations(annotation_path)

  # Canonicalize id columns to single id column.
  id_columns <- spekex::get_id_col_from_spek(spek)
  idd_data <- canonicalize_ids(raw_data, id_columns)

  # Process data and generate annotations
  annotations <- annotate(idd_data, anno_env, spek)
  if(Sys.getenv("BS_VERBOSE")){ print(annotations)}

  # URI Substitute annotations
  uri_annotations <- swap_in_uris(annotations, BS$DEFAULT_URI_LOOKUP)

  # Filter annotations to get dispositions
  dispositions <- distill_annotations(uri_annotations)
  if(Sys.getenv("BS_VERBOSE")){ print(dispositions)}

  # Create performers table as precursor to json-ification
  performers(dispositions, BS$DEFAULT_APP_ONTO_URL)
}
