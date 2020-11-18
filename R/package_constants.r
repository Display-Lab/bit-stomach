# Depend on spekex for URI constants
library(spekex)

# top level config environment
BS <- new.env()

# Annotation function naming pattern
BS$ANNO_FUNC_PATTERN <- "annotate"
# IRI for dispositions
BS$REGARDING_MEASURE <- spekex::SE$REGARDING_MEASURE
BS$REGARDING_COMPARATOR <- spekex::SE$REGARDING_COMPARATOR

# IRIs for parsing spek
BS$HAS_DISPOSITION_URI <- spekex::SE$HAS_DISPOSITION_IRI
BS$DEFAULT_APP_ONTO_URL <- spekex::SE$DEFAULT_APP_IRI
BS$HAS_PERFORMERS_URI <- spekex::SE$HAS_PERFORMERS_IRI
BS$PERFORMER_URI <- spekex::SE$PERFORMER_IRI
BS$INPUT_TABLE_IRI <- spekex::SE$INPUT_TABLE_IRI
BS$MEASURE_IRI <- spekex::SE$MEASURE_IRI
BS$COL_USE_IRI <- spekex::SE$COLUMN_USE_IRI

BS$TABLE_SCHEMA_IRI <- spekex::SE$TABLE_SCHEMA_IRI
BS$COLUMNS_IRI <- spekex::SE$COLUMNS_IRI
BS$TABLE_IRI <- spekex::SE$TABLE_IRI
BS$DIALECT_IRI <- spekex::SE$DIALECT_IRI
BS$COL_NAME_IRI <- spekex::SE$COLUMN_NAME_IRI

# Slowmo ascribee IRIs
BS$CAPABILITY_BARRIER <- spekex::SE$CAPABILITY_BARRIER_IRI
BS$NEGATIVE_TREND <- spekex::SE$NEGATIVE_TREND_IRI
BS$POSITIVE_TREND <- spekex::SE$POSITIVE_TREND_IRI
BS$NEGATIVE_GAP <- spekex::SE$NEGATIVE_GAP_IRI
BS$POSITIVE_GAP <- spekex::SE$POSITIVE_GAP_IRI
BS$PERFORMANCE_GAP <- spekex::SE$PERFORMANCE_GAP_IRI
BS$LARGE_GAP <- spekex::SE$LARGE_GAP_IRI

# Used in swap_in_uris.r as lookup for shortname names in annotations to full IRI
BS$DEFAULT_URI_LOOKUP <- list(
  performer            = BS$PERFORMER_URI,
  has_performer        = BS$HAS_PERFORMER_URI,
  uses_template        = spekex::SE$ABOUT_TEMPLATE_IRI,
  spek                 = "http://example.com/slowmo#spek",
  has_disposition      = BS$HAS_DISPOSITION_URI,
  capability_barrier   = BS$CAPABILITY_BARRIER,
  negative_trend       = BS$NEGATIVE_TREND,
  positive_trend       = BS$POSITIVE_TREND,
  negative_gap         = BS$NEGATIVE_GAP,
  positive_gap         = BS$POSITIVE_GAP,
  performance_gap      = BS$PERFORMANCE_GAP,
  large_gap            = BS$LARGE_GAP,
  achievement          = spekex::SE$ACHIEVEMENT_IRI,
  loss_content         = spekex::SE$LOSS_CONTENT_IRI,
  consec_neg_gap       = spekex::SE$CONSEC_NEG_GAP_IRI,
  cnosec_pos_gap       = spekex::SE$CONSEC_POS_GAP_IRI,
  goal_comparator      = spekex::SE$GOAL_COMPARATOR_IRI,
  social_comparator    = spekex::SE$SOCIAL_COMPARATOR_IRI,
  standard_comparator  = spekex::SE$STANDARD_COMPARATOR_IRI
)

# Default configuration
BS$DEFAULT_RUN_CONFIG <- list(
    verbose = FALSE,
    app_onto_url = BS$DEFAULT_APP_ONTO_URL,
    uri_lookup = BS$DEFAULT_URI_LOOKUP
  )

# Error Strings
BS$ERROR_INVALID_ANNOTATION_PATH <- "[Error] Path to annotations file not found."
BS$ERROR_UNREADABLE_ANNOTATION_FILE <- "[Error] Annotation file unreadable.  Check permissions."
BS$ERROR_NO_ID_COLUMN <- "[Error] Spek did not specify 'identity' ColumnUse, or 'id' column missing from data."
BS$ERROR_NO_SPEK <- "[Error] Spek not provided."

# Warning String constants
BS$WARN_NO_ANNOTATION_FUNCTIONS <- "[Warn] No annotation functions found."
