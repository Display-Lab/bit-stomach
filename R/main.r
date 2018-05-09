#' @title Main
#' @description The entry function with all the side effects.
#' @param config_path Path to configuration yaml. Use NULL to use internal defaults.
#' @param ... List of configuration overrides passed to build_config
#' @seealso build_configuration
#' @export
main <- function(spek_path = NULL, config_path = NULL, ...) {
  # Read spek
  spek <- read_spek(spek_path)

  # Build configuration
  run_config <- build_configuration(config_path, ...)

  # Ingest performance data and annotate performers based on performance data
  performers_table <- digestion(run_config)

  # Merge performer annotations with given spek
  spek_plus <- merge_performers(spek, performers_table)

  # Write Spek with annotations added to disk
  spek_json <- jsonlite::toJSON(spek_plus, auto_unbox = T)
  persist_to_disk(spek_json, config$output_dir)
}

#' @title Digestion
#' @describeIn Main
#' @param config Runtime configuration
#' @details The config parameter contains
#' @return list of performers and annotations as a table
digestion <- function(config){

  if(config$verbose == T){ print(config)}
  # Read data
  raw_data <- read_data(config$data_path)

  # Source annotation functions and additional uri lookup
  anno_env <- source_annotations(config$annotation_path)

  # Canonicalize id columns to single id column.
  idd_data <- canonicalize_ids(raw_data, config$col_spec$id_cols)

  # Process data and generate annotations
  annotations <- annotate(idd_data, anno_env, config$col_spec)
  if(config$verbose == T){ print(annotations)}

  # Filter annotations to get dispositions
  dispositions <- distill_annotations(annotations)
  if(config$verbose == T){ print(dispositions)}

  # Create performers table as precursor to json-ification
  performers(dispositions, config$app_onto_url)
}
