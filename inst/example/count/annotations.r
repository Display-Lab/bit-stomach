library(dplyr, warn.conflicts = FALSE)
library(utils)

# Annotator functions for example situation
# How to pass a guideline or static comparator into the annotation?
#  Maybe change col_spec to annotation spec? how to include in the spek?
#    col_spec + static_values

# Helper functions
# For each value, calc mean of OTHER values.
background_mean <- function(vals){
  sapply(1:length(vals),
         FUN=function(idx,values){mean(values[-idx])},
         values=vals)
}

eval_capability_barrier <- function(x){
  all(x < 0.5)
}

eval_perf_gap_neg <- function(rates, backgrounds){
  rates < 0.9 * backgrounds
}

eval_perf_gap_pos <- function(rates, backgrounds){
  rates > 1.1 * backgrounds
}

eval_perf_trend_neg <- function(vals){
  tail <- tail(vals, 3)
  tail_slope <- lm(tail~x, list(x=1:3,tail=tail))$coefficients['x']
  if(tail_slope <= -0.05){
    return(TRUE)
  }else{
    return(FALSE)
  }
}

eval_perf_trend_pos <- function(vals){
  tail <- tail(vals, 3)
  tail_slope <- lm(tail~x, list(x=1:3,tail=tail))$coefficients['x']
  if(tail_slope >= 0.05){
    return(TRUE)
  }else{
    return(FALSE)
  }
}

# Annotation functions
annotate_capability_barrier <- function(data, col_spec){
  data %>%
    mutate(rate=numerator/denominator) %>%
    group_by(id) %>%
    summarize(capability_barrier = eval_capability_barrier(rate))
}

annotate_perf_trend_neg <- function(data, col_spec){
  data %>%
    mutate(rate=numerator/denominator) %>%
    group_by(id) %>%
    summarize(perf_trend_neg=eval_perf_trend_neg(rate))
}

annotate_perf_trend_pos <- function(data, col_spec){
  data %>%
    mutate(rate=numerator/denominator) %>%
    group_by(id) %>%
    summarize(perf_trend_pos=eval_perf_trend_pos(rate))
}

annotate_perf_gap_pos <- function(data, col_spec){
  data %>%
    mutate(rate=numerator/denominator) %>%
    group_by(timepoint) %>%
    mutate(bkgd_rate = background_mean(rate),
           perf_gap_pos=eval_perf_gap_pos(rate, bkgd_rate)) %>%
    group_by(id) %>%
    filter(timepoint == max(timepoint)) %>%
    select(id, perf_gap_pos)
}

annotate_perf_gap_neg <- function(data, col_spec){
  data %>%
    mutate(rate=numerator/denominator) %>%
    group_by(timepoint) %>%
    mutate(bkgd_rate = background_mean(rate),
           perf_gap_neg=eval_perf_gap_neg(rate, bkgd_rate)) %>%
    group_by(id) %>%
    filter(timepoint == max(timepoint)) %>%
    select(id, perf_gap_neg)
}
