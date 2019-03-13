# top level config environment
BS <- new.env()

BS$DEFAULT_COL_SPEC <- list(
  "id_cols" = c("performer"),
  "perf_cols" = c("score"),
  "ordering_cols" = c("timepoint")
)

# Used in swap_in_uris.r as lookup for shortname names in annotations to full IRI
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


# Default configuration
BS$DEFAULT_RUN_CONFIG <- list(
    verbose = BS$DEFAULT_VERBOSE,
    col_spec = BS$DEFAULT_COL_SPEC,
    app_onto_url = BS$DEFAULT_APP_ONTO_URL,
    outfile = BS$DEFAULT_OUTFILE,
    data_path = system.file("example", "performer-data.csv", package = "bitstomach", mustWork = T),
    annotation_path = system.file("example", "annotations.r", package = "bitstomach", mustWork = T),
    uri_lookup = list(
      performer            = "http://example.com/slowmo#ascribee",
      has_performer        = "http://example.com/slowmo#slowmo_0000001",
      uses_template        = "http://example.com/slowmo#slowmo_0000003",
      spek                 = "http://example.com/slowmo#slowmo_0000140",
      normative_comparator = "http://example.com/slowmo#normative_comparator",
      related_location     = "http://example.com/app#related_location",
      has_part             = "http://purl.obolibrary.org/obo/bfo#BFO_0000051",
      has_disposition      = "http://purl.obolibrary.org/obo/RO_0000091",
      client_spek          = "http://example.com/app#clientname_spek")
  )

BS$DEFAULT_SPEK <- '{
  "@context": {
    "@vocab": "http://schema.org/",
    "slowmo:measure": "http://example.com/slowmo#measure"
  },
  "@type": "http://example.com/slowmo#slowmo_0000140"
}'

