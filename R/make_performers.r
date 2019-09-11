#' @title Make Performers
#' @description Create table of performers from measure-performers
#' @param m_performers List of measure-performer tibbles
#' @importFrom dplyr bind_rows
make_performers <- function(m_performers){
  df <- dplyr::bind_rows(m_performers)
  df %>%
    group_by(`@id`) %>%
    summarise_at(.vars=BS$HAS_DISPOSITION_URI, .funs=aggregate_measure_dispositions) %>%
    mutate("@type" = BS$PERFORMER_URI, `@id` = paste0("_:p", `@id`))
}

#' @title Aggregate Measure Dispositions
#' @describeIn make_performers Helper function to collapse lists of measure-dispositions to single list.
#' @param List of lists of measure-dipositions
#' @importFrom purrr reduce
aggregate_measure_dispositions <- function(x){
  result <- purrr::reduce(x, append)
  list(result)
}
