# Source all the files until this gets built as a package
source("R/canonicalize_ids.r")
source("R/annotate.r")
source("R/source_annotations.r")
source("R/build_configuration.r")
source("R/build_situation.r")
source("R/distill_annotations.r")
source("R/merge_uri_lookups.r")
source("R/performers.r")
source("R/persist_to_disk.r")
source("R/read_data.r")


# Build configuration
run_config <- build_configuration(path_to_config)

# Read data
raw_data <- read_data(run_config$data_path)

# Source annotation functions and additional uri lookup
anno_env <- source_annotations(run_config$annotation_path)

# Merge additional uri_lookup from annotation environment
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

