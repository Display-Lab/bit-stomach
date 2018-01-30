# Build configuration
run_config <- build_config(path_to_config)

# Read data
raw_data <- read_data(run_config$data_path)

# Source annotation functions and additional uri lookup
anno_env <- read_annotations(run_config$annotation_path)

# Merge additional uri_lookup from annotation environment
merged_uri_lookup <- merge_uri_lookups(run_config, anno_env)

# Canonicalize id columns to single id column.
idd_data <- canonicalize_ids(raw_data)

# Process data and generate annotations 
annotations <- annotate(idd_data, anno_env, run_config$perf_cols)

# Filter annotations to get dispositions
dispositions <- distil_annotations(annotations, merged_uri_lookup)

# Create performers table as precursor to json-ification
performer_table <- performers(dispositions)

# Build the json-ld situation
situation_json <- build_situation(performer_table, merged_uri_lookup)

# Write Situation to disk
persist_to_disk(situation_json, run_config$output_dir)
