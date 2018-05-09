#' @title Distill Annotations
#' @description Prepare annotations for jsonld export:
#'   Filter for annotations that are TRUE,
#'   Rename columns for export to jsonld,
#'   Convert annoation short names to full url
#' @import dplyr
#' @importFrom tidyr gather
distill_annotations <- function(annotations) {
  annotations %>%
    tidyr::gather(key = "disposition", value = "value", -id) %>%
    filter(value == T) %>%
    select(-value) %>%
    mutate(disposition=value_listify(disposition))
}

#' @title value listify
#' @description Wrap individual values in a list keyed by '@value'.  Puts table in correct format for conversion to json-ld
value_listify <- function(indata){
  listed <- lapply(indata, FUN=function(x){list('@value'=x)})
  return(listed)
}
