#' @title Main
#' @description The entry function with all the side effects.
#' @param spek_path Path to spek json.
#' @param annotation_path Path to file to source annotations from.
#' @param data_path Path to file to csv from which to read data.
#' @param ... List of configuration overrides passed to build_config
#' @seealso build_configuration
#' @importFrom spekex read_spek
#' @importFrom spekex write_spek
#' @export
main <- function(spek_path = NULL, annotation_path, data_path, ...) {
  # Read inputs
  spek <- spekex::read_spek(spek_path)
  raw_data <- read_data(data_path)

  # Build configuration
  run_config <- build_configuration(spek, ...)

  if(run_config$verbose == TRUE){ print(run_config) }

  # Ingest performance data and annotate performers based on performance data
  performers_table <- digestion(run_config, annotation_path, raw_data, spek)

  # Merge performer annotations with given spek
  spek_plus <- merge_performers(spek, performers_table)

  # Write Spek with annotations added to outfile
  spekex::write_spek(spek_plus)
  invisible(NULL)
}

#' @title Digestion
#' @describeIn Main
#' @description Digest the inputs specified in the runtime configuration.
#' @param config Runtime configuration
#' @details The config parameter contains
#' @return table of performers and their annotations
#' @importFrom spekex get_id_col_from_spek
digestion <- function(config, annotation_path, raw_data, spek){
  # Source annotation functions and additional uri lookup
  anno_env <- source_annotations(annotation_path)

  # Canonicalize id columns to single id column.
  id_columns <- spekex::get_id_col_from_spek(spek)
  idd_data <- canonicalize_ids(raw_data, id_columns)

  # Process data and generate annotations
  annotations <- annotate(idd_data, anno_env, spek)
  if(config$verbose == T){ print(annotations)}

  # URI Substitute annotations
  uri_annotations <- swap_in_uris(annotations, config$uri_lookup)

  # Filter annotations to get dispositions
  dispositions <- distill_annotations(uri_annotations)
  if(config$verbose == T){ print(dispositions)}

  # Create performers table as precursor to json-ification
  performers(dispositions, BS$DEFAULT_APP_ONTO_URL)
}
