#' @title Main
#' @description The entry function with all the side effects
#' @param config_path Path to configuration yaml. Use NULL to use internal defaults.
#' @param ... List of configuration overrides passed to build_config
#' @seealso build_configuration
#' @export
main <- function(config_path = NULL, ...) {
  # Build configuration
  run_config <- build_configuration(config_path, ...)

  # TODO Merge additional uri_lookup from spek

  # Run application logic
  digestion(run_config)
}

#' @title Digestion
#' @describeIn main
#' @param config Runtime configuration
digestion <- function(config){
  # Read data
  raw_data <- read_data(config$data_path)

  # Source annotation functions and additional uri lookup
  anno_env <- source_annotations(config$annotation_path)

  # Canonicalize id columns to single id column.
  idd_data <- canonicalize_ids(raw_data, config$col_spec$id_cols)

  # Process data and generate annotations
  annotations <- annotate(idd_data, anno_env, config$col_spec)

  # Filter annotations to get dispositions
  dispositions <- distill_annotations(annotations, config$uri_lookup)

  # Create performers table as precursor to json-ification
  performer_table <- performers(dispositions, "http://www.example.com/#", config$uri_lookup)

  # Build the json-ld situation
  situation_json <- build_situation(performer_table, config$uri_lookup)

  # Write Situation to disk
  persist_to_disk(situation_json, config$output_dir)
}
