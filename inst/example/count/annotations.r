library(dplyr, warn.conflicts = FALSE)

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

eval_perf_trend_neg <- function(x){
  len <- length(x)
  tail <- x[(len-2):len]
  body <- x[1:(len-3)]
  body_mean <- mean(body)
  tail_mean <- mean(tail)
  tail_slope <- lm(i~tail, list(i=1:3,tail=tail))$coefficients['tail']
  if(tail_mean < body_mean && tail_slope < 1){
    return(TRUE)
  }else{
    return(FALSE)
  }
}

eval_perf_trend_pos <- function(x){
  len <- length(x)
  tail <- x[(len-2):len]
  body <- x[1:(len-3)]
  body_mean <- mean(body)
  tail_mean <- mean(tail)
  tail_slope <- lm(i~tail, list(i=1:3,tail=tail))$coefficients['tail']
  if(tail_mean > body_mean && tail_slope > 1){
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
