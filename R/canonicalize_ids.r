#' @title Cannonicalize Ids
#' @description Concatenate id column values into single id column.
#' @param data data frame or tibble of performance data
#' @param id_cols list of column names used to uniquely identify performers
#' @return data frame or tibble with id_cols concatenated into a single 'id' column
#' @import dplyr
#' @importFrom rlang syms
canonicalize_ids <- function(data, id_cols) {
  # Handle cases where spek does not provide table schema
  if(is.null(id_cols)){return(data)}
  if(length(id_cols) == 0){return(data)}

  id_syms <- rlang::syms(id_cols)
  data %>%
    mutate(id = paste(!!!id_syms, sep = "-")) %>%
    select(-c(!!!id_syms))
}
