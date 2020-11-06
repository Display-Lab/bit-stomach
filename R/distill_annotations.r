#' @title Distill Annotations
#' @description Prepare annotations for jsonld export:
#'   Filter for annotations that are TRUE,
#'   Rename columns for export to jsonld,
#'   Convert annoation short names to full url
#' @param annotations data.frame with id column and column for each disposition.
#' @return data.frame with columns id and disposition
#' @import dplyr
#' @importFrom tidyr gather
#' @importFrom rlang abort
# RETURN VALUE EXAMPLE
# A tibble: 14 x 2
#   id    disposition
#   <chr> <list>
#   Syn1  <named list [1]> `@type`: "http://purl.obolibrary.org/obo/psdo_0000112"
#   802   <named list [1]> `@type`: "http://purl.obolibrary.org/obo/psdo_0000095"
#   1156  <named list [1]>
#   Syn1  <named list [1]>
#   Syn2  <named list [1]>
#   802   <named list [1]>

distill_annotations <- function(annotations) {
  # Guard when annotations are null
  if(is.null(annotations)){ return(annotations) }
  # Guard when id not in annoations
  if( !("id" %in% names(annotations))){ abort(BS$ERROR_NO_ID_COLUMN) }

  annotations %>%
    tidyr::gather(key = "disposition", value = "value", -id) %>%
    filter(value == T) %>%
    select(-value) %>%
    mutate(disposition=value_listify(disposition))
}

#' @title value listify
#' @description Wrap individual values in a list keyed by '@type'.  Puts table in correct format for conversion to json-ld
value_listify <- function(indata){
  listed <- lapply(indata, FUN=function(x){list('@type'=x)})
  return(listed)
}
