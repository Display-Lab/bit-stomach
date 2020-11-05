#' @title Generate Dispositions
#' @description Create performer dispositions for given data.
#' @return table of dispositions
# EXAMPLE RETURN VALUE
# A tibble
#  `@id` `http://purl.obolibrary.org/obo/RO_0000091`
#  <chr> <list>
#  1156  <list [4]>
#  802   <list [4]>
#  Syn1  <list [5]>
#  Syn2  <list [1]>
# LIST CONTENTS
#  [[1]]$`@type`: "http://purl.obolibrary.org/obo/psdo_0000095"
#  [[2]]$`@type`: "http://purl.obolibrary.org/obo/psdo_0000100"
#  [[3]]$`@type`: "http://purl.obolibrary.org/obo/psdo_0000106"
#  [[4]]$`@type`: "http://purl.obolibrary.org/obo/psdo_0000104"

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
