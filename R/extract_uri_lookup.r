#' @title Extract URI Lookup
#' @description Extract, flatten, and munge context from spek into a uri_lookup
#' @details Assumes the presence of a nested fio context.
extract_uri_lookup <- function(spek){
  ctx <- spek[['@context']]
  fio <- ctx[['fio']]

  names(fio) <- paste0("fio:", names(fio))

  return(fio)
}
