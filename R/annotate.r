#' @title Annotate
#' @description Runn annotation functions over
#' @param data Performance data
#' @param anno_env Environment containing the annotation functions.
#' @param spek Lists representation of spek
#' @return A data.frame with column for id and each annotated attribute.
#'   Values for annotated attributes are TRUE or FALSE indicating presence or absence of attribute.
#' @seealso source_annotations
#' @importFrom utils lsf.str
annotate <- function(data, anno_env, spek) {
  # Get list of annotations functions from annotation environment
  anno_func_names <- anno_func_names(anno_env)

  # One time setup to add cached values as side effect to enviroment
  setup_anno_cache(data, anno_env, spek)

  # Build arguement list to pass to each of the annotation functions
  anno_args <- list(data = data, spek = spek)

  # Names of lists will be used later in Reduce,
  #  so use function names as the names of their results.
  anno_results <- lapply(anno_func_names, FUN = run_annotation, args = anno_args, envir = anno_env)
  names(anno_results) <- anno_func_names

  # Don't let error in an annotation function halt the process.
  result_is_error <- sapply(anno_results, function(x){ "error" %in% class(x)})
  if(any(result_is_error)){ emit_annotation_errors(anno_results[result_is_error]) }

  # Reduce results list into a single annotation table
  Reduce(left_join, anno_results)
}

#' @title Setup Annotation Cache
#' @param env environment of annotation functions
#' @param spek Lists representation of spek
#' @describeIn annotate run one time setup and append cache to annotation environment
setup_anno_cache <- function(data, env, spek){
  setup_func <- lsf.str(envir=env, pattern="^setup_cache$")
  if(length(setup_func)==1){
    cache <- do.call(toString(setup_func), args=list(data=data, spek=spek), envir=env)
    env$cache <- cache
  }
  invisible(env)
}

#' @title Annotation Functions Names
#' @describeIn annotate get annotation function names from environment
#' @param env annotation environment
anno_func_names <- function(env){
  func_names <- lsf.str(envir = env, pattern = BS$ANNO_FUNC_PATTERN)
  if(length(func_names) < 1){ rlang::warn(BS$WARN_NO_ANNOTATION_FUNCTIONS) }
  return(func_names)
}

#' @title Run Annotation
#' @describeIn annotate Wrap running single annotation function to return errors for subsequent aggregation.
#' @param func_name Character string naming the annotation function to call
#' @param args List of arguments for the function call
#' @param env Environment in which to call the function
run_annotation <- function(func_name, args, envir){
  # Capture errors and return error object as result
  tryCatch( do.call(func_name, args=args, envir=envir),
            error = function(c){return(c)})
}

#' @title Emit Annotation Errors
#' @param err_list List of Errors to be emitted.
#' @describeIn annotate wrap up list of errors into single error message.
emit_annotation_errors <- function(err_list){
  header <- paste("Encountered", length(err_list), "errors in annotations:", sep=" ")
  formatted_errors <- sapply(err_list, FUN=error_reformat)

  consolidated_message <- paste0(header, formatted_errors, "\n", collapse="\n")
  rlang::abort(consolidated_message)
}

#' @title  Error Reformat
#' @param err Error to be formatted
#' @describeIn annotate Convenience function to format error call and message into character vector for repackaging.
error_reformat <- function(err){
  paste0(
    paste("in ", err$call, ":", sep=""),
    paste("  ", err$message, "\n", sep=""),
    collapse="\n")
}
