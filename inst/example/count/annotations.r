library(dplyr, warn.conflicts = FALSE)
library(utils)

# Annotator functions for example situation
# How to pass a guideline or static comparator into the annotation?
#  Maybe change col_spec to annotation spec? how to include in the spek?
#    col_spec + static_values

# Helper functions
background_aves <- function(ids, vals){
  masks <- lapply(ids, FUN=function(id,idz){idz != id}, idz=ids)
  sapply(masks, FUN=function(mask, valz){mean(valz[mask])}, vals)
}

eval_capability_barrier <- function(x){
  all(x < 0.5)
}

eval_perf_gap <- function(val, bkgd){
  cutoff <- 0.8 * bkgd
  val <= cutoff
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

annotate_gap <- function(data, col_spec){
  data %>%
    mutate(rate=numerator/denominator) %>%
    group_by(id) %>%
    summarize(mean_rate=mean(rate)) %>%
    mutate(bkgd_rate = background_aves(id, mean_rate)) %>%
    group_by(id) %>%
    summarize(perf_gap=eval_perf_gap(mean_rate, bkgd_rate))
}
