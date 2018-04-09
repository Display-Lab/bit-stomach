#' @title Build Situation 
#' @description Make JSON-LD from performer table
#' @importFrom jsonlite toJSON
#' @import jsonld
build_situation <- function(performer_table, uri_lookup){
  # Build a context that maps the attribute table column names to canonnical URIs
  ctx <- jsonlite::toJSON(uri_lookup, auto_unbox = T)
  
  # IDs need to be URIs.  Add these to the application ontology?
  doc <- paste('{"@id":"https://inference.es/app/onto#Client_Situation",',
        '"@type":"http://purl.obolibrary.org/obo/fio#FIO_0000050",',
        '"http://purl.obolibrary.org/obo/bfo#BFO_0000051":', toJSON(performer_table), '}')
  
  full <- list("@context"=uri_lookup,
               "@id"=uri_lookup$client_situation,
               "@type"= uri_lookup$situation,
               "has_part"=performer_table)
  
  # Expand and compact json document to replace the uri keys using the context
  f <- jsonlite::toJSON(full, auto_unbox = T, pretty = T)
  e <- jsonld::jsonld_expand(f)
  jsonld::jsonld_compact(e, toJSON(uri_lookup,auto_unbox = T))
}