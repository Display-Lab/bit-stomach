#' @title Merge URI Lookups
#' @description Take all uri lookups and flatten into single list
#' @importFrom rlang flatten
merge_uri_lookups <- function(...){
  args <- list(...) 
  lookups <- lapply(args, FUN=function(x){x$uri_lookup})
  flat <- rlang::flatten(lookups)
  flat[!sapply(flat, is.null)]
}
