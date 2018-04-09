#' @title Main
#' @description The entry function with all the side effects
#' @param path_to_config Path to configuration yaml. Use NULL to use internal defaults.
#' @param overrides List of configuration overrides.
#' @export
main <- function(path_to_config = NULL, overrides = NULL){
  
  # Build configuration
  run_config <- build_configuration(path_to_config)
  
  # Read data
  raw_data <- read_data(run_config$data_path)
  
  # Source annotation functions and additional uri lookup
  anno_env <- source_annotations(run_config$annotation_path)
  
  # Merge additional uri_lookup from annotation environmen#t
  merged_uri_lookup <- merge_uri_lookups(run_config, anno_env)
  
  # Canonicalize id columns to single id column.
  idd_data <- canonicalize_ids(raw_data, run_config$id_cols)
  
  # Process data and generate annotations 
  annotations <- annotate(idd_data, anno_env, run_config$perf_cols)
  
  # Filter annotations to get dispositions
  dispositions <- distill_annotations(annotations, merged_uri_lookup)
  
  # Create performers table as precursor to json-ification
  performer_table <- performers(dispositions,"http://www.example.com/#", merged_uri_lookup)
  
  # Build the json-ld situation
  situation_json <- build_situation(performer_table, merged_uri_lookup)
  
  # Write Situation to disk
  persist_to_disk(situation_json, run_config$output_dir)
} 