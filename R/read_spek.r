#' @title Read Spek
#' @description Read json-ld spek from disk or use a minimal spek.
#' @param spek_path String path to file on disk or NULL
#' @return List representation of the spek from disk or default minimal spek.
#'
#' @importFrom jsonlite fromJSON
#' @importFrom jsonld jsonld_expand
#' @importFrom readr read_file
read_spek <- function(spek_path = NULL){
  if(is.null(spek_path)){
    spek_str <- BS$DEFAULT_SPEK
    #spek_str <- readr::read_file('/tmp/minspek.json')
  } else {
    spek_str <- readr::read_file(spek_path)
  }

  expanded <- jsonld::jsonld_expand(spek_str )
  converted <- jsonlite::fromJSON(expanded, simplifyDataFrame = F)
  return(converted[[1]])
}
