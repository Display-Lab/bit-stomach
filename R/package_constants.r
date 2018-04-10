# top level config environment
BS <- new.env()

BS$DEFAULT_URI_LOOKUP <- list(
  "performer" = "http://purl.obolibrary.org/obo/fio#FIO_0000001",
  "situation" = "http://purl.obolibrary.org/obo/fio#FIO_0000050",
  "has_part" = "http://purl.obolibrary.org/obo/bfo#BFO_0000051",
  "has_disposition" = "http://purl.obolibrary.org/obo/RO_0000091",
  "client_situation" = "https://inference.es/app/onto#Client_Situation"
)
