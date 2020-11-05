# Using Annotation Testing Harness

A set of functions that facilitate setting up the state in which annotations are run.
Can be used to debug or develop annotations.


## Run annotations for single measure (first measure)

```R
# Example of Working with vignette
library(bitstomach)

anno_env <- source_annotations('/home/grosscol/workspace/vra/vignettes/bob/annotations.r')
spek <- spekex::read_spek('/home/grosscol/workspace/vra/vignettes/bob/spek.json')
col_types <- spekex::cols_for_readr(spek)
raw_data <- read_data('/home/grosscol/workspace/vra/vignettes/bob/performance.csv', col_types)

measure_data <- h_setup_measure_data(spek, raw_data)

dispositions <- h_single_measure_run(spek, anno_env, measure_data)

```

The table of dispositions can then be examined for the expected annotations.
```R
library(dplyr)

dispositions

# # A tibble: 4 x 2
#   `@id` `http://purl.obolibrary.org/obo/RO_0000091`
#   <chr> <list>                                     
# 1 Bob   <list [3]>                                 
# 2 Peer1 <list [1]>                                 
# 3 Peer2 <list [2]>                                 
# 4 Peer3 <list [3]>

bobs_dispos <- dispositions %>% filter(`@id` == 'Bob') %>% pull(2)
str(bobs_dispos)

# List of 1
#  $ :List of 3
#   ..$ :List of 1
#   .. ..$ @type: chr "http://purl.obolibrary.org/obo/psdo_0000095"
#   ..$ :List of 1
#   .. ..$ @type: chr "http://purl.obolibrary.org/obo/psdo_0000104"
#   ..$ :List of 1
#   .. ..$ @type: chr "http://purl.obolibrary.org/obo/psdo_0000099"
```

## Setup environment as would exist inside a call in annotations.

Get the annotation function args
```R
# Example of Working with vignette
library(bitstomach)

anno_env <- source_annotations('/home/grosscol/workspace/vra/vignettes/bob/annotations.r')
spek <- spekex::read_spek('/home/grosscol/workspace/vra/vignettes/bob/spek.json')
col_types <- spekex::cols_for_readr(spek)
raw_data <- read_data('/home/grosscol/workspace/vra/vignettes/bob/performance.csv', col_types)
measure_data <- h_setup_measure_data(spek, raw_data)

anno_call_args <- h_setup_annotation_call_args(spek, anno_env, measure_data)

```

With those in hand, both the args and the enclosing frame (`anno_env`) can be attached to the current search() path so the annotation function can be stepped through and examined in the global workspace.

```R
attach(anno_env)
attach(anno_call_args)

```

Individual lines from your annotations functions can be run from your console:

```R
eval_achievement <- function(x, comp){
  if(length(x) < 2){ return(FALSE)}

  bools <- x >= comp
  return( sum(bools)==1 & dplyr::last(bools) == TRUE)
}

annotate_achievement <- function(data, spek){
  time <- cache$time_col_sym
  rate <- cache$rate_col_sym
  id <- cache$id_col_sym

  all_ids_df <- data %>% select(!!id) %>% distinct

  elidgibile_ids <- data %>%
    dplyr::filter(!!time == max(!!time)) %>%
    pull(!!id) %>%
    unique

  data %>%
    dplyr::filter(!!id %in% elidgibile_ids) %>%
    arrange(!!time) %>%
    group_by(!!id) %>%
    summarize( achievement = eval_achievement(!!rate,cache$comparator)) %>%
    right_join(all_ids_df)
}

# Run individual lines e.g.
id <- cache$id_col_sym
all_ids_df <- data %>% select(!!id) %>% distinct

```
