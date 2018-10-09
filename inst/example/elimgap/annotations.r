library(dplyr, warn.conflicts = FALSE)

# Annotator functions for example situation

# Helper functions

## Mastery evaluation
eval_mastery_unknown <- function(x){ 10 >= mean(x) && mean(x) >= 7 }

## Gap size evaluation
GUIDELINE <- 10

## Gap size evaluation
eval_small_gap <- function(x){ 
  gap <- (GUIDELINE - x) 
  1 >= gap && gap > 0
}

eval_medium_gap <- function(x){ 
  gap <- (GUIDELINE - x) 
  3 >= gap && gap > 1
}

eval_large_gap <- function(x){ 
  gap <- (GUIDELINE - x) > 3
}


# Annotation functions
annotate_negative_gap <- function(data, col_spec){
  data %>%
    group_by(id) %>%
    dplyr::filter(timepoint == max(timepoint)) %>%
    summarize(negative_gap = performance < GUIDELINE )
}

annotate_small_gap <- function(data, col_spec){
  data %>% group_by(id) %>% 
    dplyr::filter(timepoint == max(timepoint)) %>%
    summarize(small_gap = eval_small_gap(performance))
}

annotate_medium_gap <- function(data, col_spec){
  data %>% group_by(id) %>% 
    dplyr::filter(timepoint == max(timepoint)) %>%
    summarize(medium_gap = eval_medium_gap(performance))
}

annotate_large_gap <- function(data, col_spec){
  data %>% group_by(id) %>% 
    dplyr::filter(timepoint == max(timepoint)) %>%
    summarize(large_gap = eval_large_gap(performance))
}

annotate_mastery_present <- function(data, col_spec){
  data %>% group_by(id) %>% 
    summarize(mastery_present = mean(performance) > 10)
}

annotate_mastery_absent <- function(data, col_spec){
  data %>% group_by(id) %>% 
    summarize(mastery_absent = mean(performance) < 7)
}

annotate_mastery_unknown <- function(data, col_spec){ 
  data %>% group_by(id) %>% 
    summarize(mastery_unknown = eval_mastery_unknown(performance))
}
