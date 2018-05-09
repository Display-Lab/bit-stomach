# top level config environment
BS <- new.env()

BS$DEFAULT_COL_SPEC <- list(
  "id_cols" = c("performer"),
  "perf_cols" = c("score"),
  "ordering_cols" = c("timepoint")
)

BS$DEFAULT_APP_ONTO_URL <- "https://inference.es/app/onto#"
BS$HAS_PERFORMERS_URI <- "http://purl.obolibrary.org/obo/fio#HasPerformer"
BS$PERFORMER_URI <- "http://purl.obolibrary.org/obo/fio#FIO_0000001"
BS$SITUATION_URI <- "http://purl.obolibrary.org/obo/fio#FIO_0000050"
BS$HAS_PART_URI <- "http://purl.obolibrary.org/obo/bfo#BFO_0000051"
BS$HAS_DISPOSITION_URI <- "http://purl.obolibrary.org/obo/RO_0000091"
BS$CLIENT_SITUATION_URI <- "https://inference.es/app/onto#Client_Situation"

BS$DEFAULT_VERBOSE <- FALSE
