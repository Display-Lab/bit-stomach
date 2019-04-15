#' @title Annotate
#' @description Runn annotation functions over
#' @param data Performance data
#' @param anno_env Environment containing the annotation functions.
#' @param col_spec Lists of id_cols, ordering_cols, perf_cols
#' @return A data.frame with column for id and each annotated attribute.
#'   Values for annotated attributes are TRUE or FALSE indicating presence or absence of attribute.
#' @seealso source_annotations
#' @importFrom utils lsf.str
annotate <- function(data, anno_env, col_spec) {
  # Get list of annotations functions from annotation environment
  anno_func_names <- lsf.str(envir = anno_env, pattern = "annotate")

  if(length(anno_func_names) < 1){
    rlang::warn(BS$WARN_NO_ANNOTATION_FUNCTIONS)
  }

  # One time setup to add cached values to annotation environment
  setup_func <- lsf.str(envir=anno_env, pattern="^setup_cache$")
  if(length(setup_func)==1){
    # TODO implement passing spek into annotate and annotations
    cache <- do.call('setup_cache', args=list(data=data, spek=list()), envir=anno_env)
    anno_env$cache <- cache
  }

  # Build arguement list to pass to each of the annotation functions
  anno_args <- list(data = data, col_spec = col_spec)

  # Create an annotation table per each annotation function
  #anno_results <- lapply(anno_func_names, do.call, args = anno_args, envir = anno_env)

  # Emit errors
  anno_results <- lapply(anno_func_names, FUN = run_annotation, args = anno_args, envir = anno_env)

  result_is_error <- sapply(anno_results, function(x){ "error" %in% class(x)})

  if(any(result_is_error)){
    emit_annotation_errors(anno_results[result_is_error])
  }

  # Reduce results list into a single annotation table
  Reduce(left_join, anno_results)
}

#' @title Run Annotation
#' @describeIn annotate
#' @description Wrap running single annotation function to return errors for subsequent aggregation.
#' @param func_name Character string naming the annotation function to call
#' @param args List of arguments for the function call
#' @param env Environment in which to call the function
run_annotation <- function(func_name, args, envir){
  # Capture errors and return error object as result
  tryCatch( do.call(func_name, args=args, envir=envir),
            error = function(c){return(c)})
}

#' @title Emit Annotation Errors
#' @describeIn annotate
#' @description wrap up list of errors into single error message.
emit_annotation_errors <- function(err_list){
  header <- paste("Encountered", length(err_list), "errors in annotations:", sep=" ")
  formatted_errors <- sapply(err_list, FUN=error_reformat)

  consolidated_message <- paste0(header, formatted_errors, "\n", collapse="\n")
  rlang::abort(consolidated_message)
}

#' @title  Error Reformat
#' @describeIn annotate
#' @description Convenience function to format error call and message into character vector for repackaging.
error_reformat <- function(err){
  paste0(
    paste("in ", err$call, ":", sep=""),
    paste("  ", err$message, "\n", sep=""),
    collapse="\n")
}
