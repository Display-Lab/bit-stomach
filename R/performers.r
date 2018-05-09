#' @title Performers
#' @description Condense data frame with single row per performer and list of their annotations.
#' @note Convenient format for subsequent export to jsonld
performers <- function(dispositions, app_onto_url) {
  dispositions %>%
    group_by(id) %>%
    summarise(has_disposition = list(disposition)) %>%
    mutate("@type" = BS$PERFORMER_URI, id = paste0(app_onto_url, id)) %>%
    rename("@id" = id, !!BS$HAS_DISPOSITION_URI := has_disposition)
}
