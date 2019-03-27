#' @title Parse Column Specification
#' @description Extract column specification from a spek convert into internal use=name list.
#' @param spek List representation of spek
#' @return List of column specification or empty list
parse_col_spec <- function(spek){
  col_spec <- list(id_cols= get_id_col_from_spek(spek),
                   val_cols= get_value_or_numerator_col_from_spek(spek))
  return(col_spec)
}
