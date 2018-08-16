# top level config environment
BS <- new.env()

BS$DEFAULT_COL_SPEC <- list(
  "id_cols" = c("performer"),
  "perf_cols" = c("score"),
  "ordering_cols" = c("timepoint")
)

BS$DEFAULT_APP_ONTO_URL <- "http://example.com/app#"
BS$HAS_PERFORMERS_URI <- "http://example.com/slowmo#slowmo_0000001"
BS$PERFORMER_URI <- "http://example.com/slowmo#ascribee"
BS$HAS_DISPOSITION_URI <- "http://purl.obolibrary.org/obo/RO_0000091"

BS$DEFAULT_VERBOSE <- FALSE
