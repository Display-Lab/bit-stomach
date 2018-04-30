#' @title Main
#' @description The entry function with all the side effects.
#' @param config_path Path to configuration yaml. Use NULL to use internal defaults.
#' @param ... List of configuration overrides passed to build_config
#' @seealso build_configuration
#' @export
main <- function(spek_path = NULL, config_path = NULL, ...) {
  # Read spek
  spek <- read_spek(spek_path)
  # Extract URI lookup and add to
  spek_uri <- extract_uri_lookup(spek)

  # Build configuration
  run_config <- build_configuration(config_path, uri_lookup=spek_uri, ...)

  # Ingest performance data and annotate performers based on performance data
  digestion(run_config)

  # TODO Merge performers list and annotations with spek performers

  # TODO Persist updated spek to disk
}

#' @title Digestion
#' @describeIn Main
#' @param config Runtime configuration
#' @return list of performers and annotations
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
  dispositions <- distill_annotations(annotations, config$uri_lookup)
  if(config$verbose == T){ print(dispositions)}

  # Create performers table as precursor to json-ification
  performer_table <- performers(dispositions, "http://www.example.com/#", config$uri_lookup)

  # TODO: Build performers json-ld

  # Build the json-ld situation
  situation_json <- build_situation(performer_table, config$uri_lookup)
  if(config$verbose == T){ print(situation_json)}

  # Write Situation to disk
  persist_to_disk(situation_json, config$output_dir)
}
