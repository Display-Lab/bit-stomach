# Template annotations
#  Annotations are run once per measure.

############
# Run Once #
# This function will be executed once before the start of the run. The result stored
# in a variable 'cache'. That cache will be in the calling environment of the annotation functions.

setup_cache <- function(data, spek){
  cache <- list()

  # Id column will always be id
  cache$id_colname      <- 'id'
  cache$id_col_sym      <- rlang::sym(cache$id_colname)

  # Hardcode column names.  Extract from spek in subsequent versions.
  cache$denom_colname   <- 'Denominator'
  cache$numer_colname   <- 'Passed_Count'
  cache$time_colname    <- 'Month'
  cache$measure_colname <- 'Measure_Name'

  # Make a symbol of the numerator and denominator columns
  cache$denom_col_sym   <- rlang::sym(cache$denom_colname)
  cache$numer_col_sym   <- rlang::sym(cache$numer_colname)
  cache$time_col_sym    <- rlang::sym(cache$time_colname)
  cache$measure_col_sym <- rlang::sym(cache$measure_colname)

  # Calculate peer average by measure
  #cache$peer_mean <- calc_peer_measure_means(data, cache)
  cache$comparator <- 0.90

  return(cache)
}

######################
# Annotation Functions
#   These will be run once per measure  Each is epected to return data frame with: id, annotation_name
#   Annotation names should be unique They are replaced with IRIS via the lookup table in the
#   package constants: BS$DEFAULT_URI_LOOKUP
#   The variable cache is available in the calling env of these functions.

annotate_negative_gap <- function(data, spek){
  id <- cache$id_col_sym
  data %>% group_by(!!id) %>% summarize( negative_gap = FALSE)
}

annotate_positive_gap <- function(data, spek){
  id <- cache$id_col_sym
  data %>% group_by(!!id) %>% summarize( positive_gap = FALSE)
}

annotate_negative_trend <- function(data, spek){
  id <- cache$id_col_sym
  data %>% group_by(!!id) %>% summarize( negative_trend = FALSE)
}

annotate_positive_trend <- function(data, spek){
  id <- cache$id_col_sym
  data %>% group_by(!!id) %>% summarize( positive_trend = FALSE)
}

annotate_capability_barrier <- function(data, spek){
  id <- cache$id_col_sym
  data %>% group_by(!!id) %>% summarize( capability_barrier = FALSE)
}

annotate_performance_gap <- function(data, spek){
  id <- cache$id_col_sym
  data %>% group_by(!!id) %>% summarize( performance_gap = FALSE)
}

annotate_large_gap <- function(data, spek){
  id <- cache$id_col_sym
  data %>% group_by(!!id) %>% summarize( large_gap = FALSE)
}

annotate_achievement <- function(data, spek){
  id <- cache$id_col_sym
  data %>% group_by(!!id) %>% summarize( achievement = FALSE)
}

annotate_consec_neg_gap <- function(data, spek){
  id <- cache$id_col_sym
  data %>% group_by(!!id) %>% summarize( consec_neg_gap = FALSE)
}

annotate_consec_pos_gap <- function(data, spek){
  id <- cache$id_col_sym
  data %>% group_by(!!id) %>% summarize( consec_pos_gap = FALSE)
}

annotate_goal_comparator <- function(data, spek){
  id <- cache$id_col_sym
  data %>% group_by(!!id) %>% summarize( goal_comparator = FALSE)
}

annotate_social_comparator <- function(data, spek){
  id <- cache$id_col_sym
  data %>% group_by(!!id) %>% summarize( social_comparator = FALSE)
}

annotate_standard_comparator <- function(data, spek){
  id <- cache$id_col_sym
  data %>% group_by(!!id) %>% summarize( standard_comparator = FALSE)
}
