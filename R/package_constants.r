# top level config environment
BS <- new.env()

BS$DEFAULT_COL_SPEC <- list(
  "id_cols" = c("performer"),
  "perf_cols" = c("score"),
  "ordering_cols" = c("timepoint")
)

BS$DEFAULT_URI_LOOKUP <- list(
  performer            = "http://example.com/slowmo#ascribee",
  has_performer        = "http://example.com/slowmo#slowmo_0000001",
  uses_template        = "http://example.com/slowmo#slowmo_0000003",
  spek                 = "http://example.com/slowmo#slowmo_0000140",
  normative_comparator = "http://example.com/slowmo#normative_comparator",
  related_location     = "http://example.com/app#related_location",
  has_part             = "http://purl.obolibrary.org/obo/bfo#BFO_0000051",
  has_disposition      = "http://purl.obolibrary.org/obo/RO_0000091",
  client_spek          = "http://example.com/app#clientname_spek"
)

BS$DEFAULT_APP_ONTO_URL <- "http://example.com/app#"
BS$HAS_PERFORMERS_URI <- "http://example.com/slowmo#slowmo_0000001"
BS$PERFORMER_URI <- "http://example.com/slowmo#ascribee"
BS$HAS_DISPOSITION_URI <- "http://purl.obolibrary.org/obo/RO_0000091"
BS$DEFAULT_OUTFILE <- stdout()

BS$DEFAULT_VERBOSE <- FALSE
