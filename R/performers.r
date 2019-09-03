#' @title Performers
#' @param dispositions data.frame of with cols: id, disposition.
#' @param app_onto_url base application ontology url
#' @description Condense data frame with single row per performer and list of their annotations.
#'   Basically take distilled annotations and make a performers table of them.
#' @note Convenient format for subsequent export to jsonld
#' @import dplyr
#' @importFrom rlang !! :=
performers <- function(dispositions) {
  if(is.null(dispositions)){ return(data.frame())}
  dispositions %>%
    group_by(id) %>%
    summarise(has_disposition = list(disposition)) %>%
    rename("@id" = id, !!BS$HAS_DISPOSITION_URI := has_disposition)
}
