
# Condense to table with single row per performer and list of their annoations
#  Convenient format for export to JSON-LD
performers <- function(dispositions, app_onto_url, uri_lookup){
  dispositions %>%
    summarise(has_disposition=list(disposition)) %>%
    mutate("@type"=uri_lookup$performer, id=paste0(app_onto_url,id))  %>%
    rename("@id"=id, !!uri_lookup$has_disposition := has_disposition)
}
