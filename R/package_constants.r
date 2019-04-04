# top level config environment
BS <- new.env()

# Used in swap_in_uris.r as lookup for shortname names in annotations to full IRI
BS$DEFAULT_URI_LOOKUP <- list(
  performer            = "http://purl.obolibrary.org/obo/psdo_0000085",
  has_performer        = "http://example.com/slowmo#IsAboutPerformer",
  uses_template        = "http://example.com/slowmo#IsAboutTemplate",
  spek                 = "http://example.com/slowmo#spek",
  normative_comparator = "http://example.com/slowmo#NormativeComparator",
  related_location     = "http://example.com/slowmo#RelatedLocation",
  has_part             = "http://purl.obolibrary.org/obo/bfo#BFO_0000051",
  has_disposition      = "http://purl.obolibrary.org/obo/RO_0000091",
  client_spek          = "http://example.com/app#clientname_spek"
)

# IRIs for parsing spek
BS$HAS_DISPOSITION_URI <- "http://purl.obolibrary.org/obo/RO_0000091"
BS$DEFAULT_APP_ONTO_URL <- "http://example.com/app#"
BS$HAS_PERFORMERS_URI <- "http://example.com/slowmo#IsAboutPerformer"
BS$PERFORMER_URI <- "http://purl.obolibrary.org/obo/psdo_0000085"
BS$INPUT_TABLE_IRI <- "http://example.com/slowmo#InputTable"
BS$MEASURE_IRI <- "http://example.com/slowmo#Measure"
BS$COL_USE_IRI <- "http://example.com/slowmo#ColumnUse"

BS$TABLE_SCHEMA_IRI <- "http://www.w3.org/ns/csvw#tableSchema"
BS$COLUMNS_IRI <- "http://www.w3.org/ns/csvw#columns"
BS$TABLE_IRI <- "http://www.w3.org/ns/csvw#Table"
BS$DIALECT_IRI <- "http://www.w3.org/ns/csvw#dialect"
BS$COL_NAME_IRI <- "http://www.w3.org/ns/csvw#name"


# Default configuration
BS$DEFAULT_OUTFILE <- stdout()
BS$DEFAULT_VERBOSE <- FALSE
BS$DEFAULT_RUN_CONFIG <- list(
    verbose = BS$DEFAULT_VERBOSE,
    col_spec = list(id_cols=list(), val_cols=list()),
    app_onto_url = BS$DEFAULT_APP_ONTO_URL,
    outfile = BS$DEFAULT_OUTFILE,
    data_path = system.file("example", "performer-data.csv", package = "bitstomach", mustWork = T),
    annotation_path = system.file("example", "annotations.r", package = "bitstomach", mustWork = T),
    uri_lookup = list(
      performer            = "http://purl.obolibrary.org/obo/psdo_0000085",
      has_performer        = "http://example.com/slowmo#IsAboutPerformer",
      uses_template        = "http://example.com/slowmo#IsAboutTemplate",
      spek                 = "http://example.com/slowmo#spek",
      normative_comparator = "http://example.com/slowmo#NormativeComparator",
      related_location     = "http://example.com/app#RelatedLocation",
      has_part             = "http://purl.obolibrary.org/obo/bfo#BFO_0000051",
      has_disposition      = "http://purl.obolibrary.org/obo/RO_0000091",
      client_spek          = "http://example.com/app#clientname_spek")
  )

BS$DEFAULT_SPEK <- '{
  "@context": {
    "@vocab": "http://schema.org/",
    "slowmo:Measure": "http://example.com/slowmo#Measure"
  },
  "@type": "http://example.com/slowmo#spek"
}'

