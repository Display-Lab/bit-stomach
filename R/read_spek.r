#' @title Read Spek
#' @description Read json-ld spek
#' @importFrom jsonlite fromJSON
read_spek <- function(path = NULL){
  if(is.null(path)){
    path <- system.file("example","basic","spek.json",package="bitstomach")
  }

  jsonlite::fromJSON(path, simplifyVector = F)
}
