# Use annotation functions to annotate data

annotate <- function(anno_env, data, perf_cols){
  # Get list of annotations functions from annotation environment
  anno_func_names <- lsf.str(envir=anno_env, pattern="annotate")
  
  # Build arguement list to pass to each of the annotation functions
  anno_args <- list(data=data, perf_cols=perf_cols)
  
  # Create an annotation table per each annotation function
  anno_results <- lapply(anno_func_names, do.call, args=anno_args, envir=anno_env)
  
  # Reduce results list into a single annotation table
  Reduce(left_join, anno_results)
}