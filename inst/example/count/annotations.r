library(zoo, warn.conflicts = FALSE)
library(dplyr, warn.conflicts = FALSE)

# Annotator functions for example situation
# How to pass a guideline or static comparator into the annotation?
#  Maybe change col_spec to annotation spec? how to include in the spek?
#    col_spec + static_values

# URIs specific to this annotation set
uri_lookup <- list(
  "capability_barrier"    = "http://purl.obolibrary.org/obo/fio#CapbilityBarrier",
  "negative_signal"       = "http://purl.obolibrary.org/obo/fio#NegativeSignal",
  "positive_signal"       = "http://purl.obolibrary.org/obo/fio#PositiveSignal",
  "perf_gap"              = "http://purl.obolibrary.org/obo/fio#PerformanceGap",
  "perf_trend_pos"        = "http://purl.obolibrary.org/obo/fio#PerformanceTrendPositive",
  "perf_trend_neg"        = "http://purl.obolibrary.org/obo/fio#PerformanceTrendNegative"
)

# Helper functions

eval_mastery <- function(x){
  # if any score is above a 16, has mastery
  if(any(x > 15)){ return(TRUE) }
  # If any three scores in a row are higher than the threshold 10, has mastery
  b_above_lim <- x > 10
  three_in_row <- rollmean(b_above_lim, 3) > 0.9
  if(any(three_in_row)){ return(TRUE)}
  # else, default to false for has_mastery
  return(FALSE)
}

eval_downward <- function(x){
  len <- length(x)
  tail <- x[(len-2):len]
  body <- x[1:(len-3)]
  body_mean <- mean(body)
  tail_mean <- mean(tail)
  tail_slope <- lm(i~tail, list(i=1:3,tail=tail))$coefficients['tail']
  if(tail_mean < body_mean && tail_slope < 1) {return(TRUE)}
  return(FALSE)
}

# Annotation functions

# return mastery_summ
annotate_mastery <- function(data, perf_cols){
  data %>%
    group_by(id) %>%
    summarise_at(.funs=eval_mastery, .vars=perf_cols) %>%
    rename_at(.vars=perf_cols, .funs=function(x){'has_mastery'})
}

# Examine each performer for notHasMastery
# Inverse of the logic for hasMastery, but this might not always be the case

# Examine each performer for hasDownwardTrend
# return down_summ
annotate_downtrend <- function(data, perf_cols){
  data %>%
    group_by(id) %>%
    summarise_at(.funs=eval_downward, .vars=perf_cols) %>%
    rename_at(.vars=perf_cols, .funs=function(x){'has_downward'})
}

