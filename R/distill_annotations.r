#' @title Distill Annotations
#' @description Prepare annotations for jsonld export: 
#'   Filter for annotations that are TRUE,
#'   Rename columns for export to jsonld,
#'   Convert annoation short names to full url
#' @import dplyr
distill_annotations <- function(annotations, uri_lookup){
  annotations %>%
    gather(key='disposition', value="value", -id) %>%
    filter(value==T) %>%
    select(-value) %>%
    group_by(id) %>%
    mutate(disposition=recode(disposition, !!!uri_lookup)) 
}
