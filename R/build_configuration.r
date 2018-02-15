# Build runtime configuration
library('config')
library('here')

DEFAULT_URI_LOOKUP <- list(
  "performer"       = "http://purl.obolibrary.org/obo/fio#FIO_0000001",
  "situation"       = "http://purl.obolibrary.org/obo/fio#FIO_0000050",
  "has_part"        = "http://purl.obolibrary.org/obo/bfo#BFO_0000051",
  "has_disposition" =  "http://purl.obolibrary.org/obo/RO_0000091",
  "client_situation" = "https://inference.es/app/onto#Client_Situation")

build_configuration <- function(path_to_config){
  list( uri_lookup = DEFAULT_URI_LOOKUP,
        app_onto_url = "https://inference.es/app/onto#",
        data_path = file.path(here(),"example","input","performer-data.csv"),
        output_dir = file.path("","tmp","bstomach"),
        annotation_path = file.path(here(),"example","input","annotations.r"),
        id_cols = c('performer'),
        perf_cols = c('score'),
        time_col = c('timepoint')
        )
}