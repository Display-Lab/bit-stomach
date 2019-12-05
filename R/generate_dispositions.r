#' @title Generate Dispositions
#' @description Create performer dispositions for given data.
#' @return table of dispositions
generate_dispositions <- function(data, anno_env, spek){
  # Process data and generate annotations
  annotations <- annotate(data, anno_env, spek)
  if(Sys.getenv("BS_VERBOSE") == T){ print(annotations)}

  # URI Substitute annotations
  uri_annotations <- swap_in_uris(annotations, BS$DEFAULT_URI_LOOKUP)

  # Filter annotations to get dispositions
  dispositions <- distill_annotations(uri_annotations)
  if(Sys.getenv("BS_VERBOSE") == T){ print(dispositions)}

  # Create performers table as precursor to json-ification
  aggregate_dispositions(dispositions)
}
