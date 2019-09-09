#' @title Aggregate Dispositions
#' @param dispositions data.frame of with cols: id, disposition.
#' @description Condense data frame with single row per performer and list of their annotations.
#'   Basically take distilled annotations and condense by id.
#' @import dplyr
#' @importFrom rlang !! :=
aggregate_dispositions <- function(dispositions) {
  if(is.null(dispositions)){ return(data.frame())}
  dispositions %>%
    group_by(id) %>%
    summarise(has_disposition = list(disposition)) %>%
    rename("@id" = id, !!BS$HAS_DISPOSITION_URI := has_disposition)
}
