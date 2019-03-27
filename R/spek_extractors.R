#' @title Get ID Columns from Spek
#' @description Extract ID column names from spek
#' @note Copied wholsale from DisplayLab/fraisty
get_id_col_from_spek <- function(spek) {
  column_list <- get_column_list(spek)

  column_names <- sapply(column_list, FUN=get_name_of_column)
  column_uses <- sapply(column_list, FUN=get_use_of_column)
  return(column_names[which(column_uses == "identifier")])
}

#' @title Get Value or Numerator Column Names from Spek
#' @description Extract the value and numerator columsn from spek
#' @describeIn get_id_col_from_spek
get_value_or_numerator_col_from_spek <- function(spek) {
  column_list <- get_column_list(spek)

  column_names <- sapply(column_list, FUN=get_name_of_column)
  column_uses <- sapply(column_list, FUN=get_use_of_column)
  return(column_names[which(column_uses == "value" | column_uses == "numerator")])
}

#' @title Get Column List
#' @description Extract the columns from table schema of input table of spek
#' @note Copied wholsale from DisplayLab/fraisty
get_column_list <- function(spek) {
  spek[[BS$INPUT_TABLE_IRI]][[1]][[BS$TABLE_SCHEMA_IRI]][[1]][[BS$COLUMNS_IRI]]
}

#' @title Get Column List
#' @description Extract name attribute values from columns in column specification
#' @note Copied wholsale from DisplayLab/fraisty
get_name_of_column <- function(column_specification) {
  column_specification[[BS$COL_NAME_IRI]][[1]][['@value']]
}

#' @title Get Use of Column
#' @description Extract use attribute values from columns in column specification
#' @note Copied wholsale from DisplayLab/fraisty
get_use_of_column <- function(column_specification) {
  column_specification[[BS$COL_USE_IRI]][[1]][['@value']]
}
