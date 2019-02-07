# Source the annotations for the situation into anno env.
#' @title Source Annotations
#' @description Source the annotations.r file which contain the fucntions to apply to the
#'   data in order to make inferences about performers from the data.
#' @param path Path too annotations R file.
#' @return An environment with the evaluated the contents of the annotations.R
#' @note Annotation functions will be passed two arguements: data and col_spec
#'   The col_spec is a list of three character vectors: id_cols, ordering_cols, perf_cols
source_annotations <- function(path) {
  anno_env <- new.env(parent = .BaseNamespaceEnv)
  source(path, local = anno_env)
  return(anno_env)
}
