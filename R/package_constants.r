# top level config environment
BS <- new.env()

BS$DEFAULT_URI_LOOKUP <- list(
  "fio:performer" = "http://purl.obolibrary.org/obo/fio#FIO_0000001",
  "fio:situation" = "http://purl.obolibrary.org/obo/fio#FIO_0000050",
  "has_part" = "http://purl.obolibrary.org/obo/bfo#BFO_0000051",
  "has_disposition" = "http://purl.obolibrary.org/obo/RO_0000091",
  "client_situation" = "https://inference.es/app/onto#Client_Situation"
)

BS$DEFAULT_COL_SPEC <- list(
  "id_cols" = c("performer"),
  "perf_cols" = c("score"),
  "ordering_cols" = c("timepoint")
)

BS$DEFAULT_APP_ONTO_URL <- "https://inference.es/app/onto#"
BS$HAS_PERFORMERS_URI <- "http://purl.obolibrary.org/obo/fio#HasPerformer"
BS$DEFAULT_VERBOSE <- FALSE
