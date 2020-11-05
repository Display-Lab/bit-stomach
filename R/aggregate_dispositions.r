#' @title Aggregate Dispositions
#' @description Condense data frame of rows with id and single annotation to
#'   data frame with one row per id and a list of annotations as the value of the 2nd column.
#' @param dispositions data.frame of with cols: id, disposition.
#' @import dplyr
#' @importFrom rlang !! :=
# EXAMPLE RETURN VALUE
# A tibble
#  `@id` `http://purl.obolibrary.org/obo/RO_0000091`
#  <chr> <list>
#  1156  <list [4]>
#  802   <list [4]>
aggregate_dispositions <- function(dispositions) {
  if(is.null(dispositions)){ return(data.frame())}
  dispositions %>%
    group_by(id) %>%
    summarise(has_disposition = list(disposition)) %>%
    rename("@id" = id, !!BS$HAS_DISPOSITION_URI := has_disposition)
}
