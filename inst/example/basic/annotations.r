library(zoo, warn.conflicts = FALSE)
library(dplyr, warn.conflicts = FALSE)

# Annotator functions for example situation
# Annotation functions need to be aware of column names apriori
# Passing col_spec here, but it is unused

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
annotate_mastery <- function(data, col_spec){
  data %>%
    group_by(id) %>%
    summarise_at(.funs=eval_mastery, .vars=c('score')) %>%
    rename_at(.vars=c('score'), .funs=function(x){'has_mastery'})
}

# Examine each performer for hasDownwardTrend
annotate_downtrend <- function(data, col_spec){
  data %>%
    group_by(id) %>%
    summarise_at(.funs=eval_downward, .vars=c('score')) %>%
    rename_at(.vars=c('score'), .funs=function(x){'has_downward'})
}
