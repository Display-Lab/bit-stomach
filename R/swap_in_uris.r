#' @title swap uris for column or list names
#' @description Swap in URIS for names using the config's uri lookup
#' @param annotations tibble, dataframe, list with names.
#' @param uri_lookup list in the form of name=uri.
#' @return annotations object with names replaced by uris from lookup when applicable
swap_in_uris <- function(annotations, uri_lookup=list()) {
  new_names <- sapply(names(annotations), lookup_new_name, lu_list=uri_lookup, USE.NAMES = F)
  names(annotations) <- new_names
  return(annotations)
}

#' @title lookup new name
#' @describeIn swap_in_uris
#' @param x name to lookup
#' @param lu_list lookup list to check x against names for value of new name
#' @return new name or original x if x not present in names of lookup list.
lookup_new_name <- function(x, lu_list){
  lu_flat <- unlist(lu_list)
  res <- lu_flat[x]
  ifelse(is.na(res), x, res)
}
