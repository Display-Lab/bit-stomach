library(dplyr, warn.conflicts = FALSE)
library(readr)
library(here)
library(zoo)
library(jsonld)

# Parameters path to CSV and config,
#' @param data_path path to data csv file
#' @param meta_path path to csv metadata file
#' @return Annotations of performers


# All of the vars will need to be handled with quasiquotation in order to be params
# for the dplyr functions.  See:
# https://cran.r-project.org/web/packages/dplyr/vignettes/programming.html


# Name of column that ids a performer  
id_cols <- c('id')

# Names of columns to be analyzed for performance signals
perf_cols <- c('perf')

# Name of column that contains time information
time_col <- c('time')

data_path <- file.path(here(),"example","input","data.csv")

# Read in data frame
df <- read_csv(data_path)

# summarize with list of column names
df %>% group_by_at(.vars=c('id')) %>% summarise_at(.funs=mean, .vars=c('perf'))

# Examine each performer for hasMastery
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
mastery_summ <- df %>% 
  group_by_at(.vars=id_cols) %>% 
  summarise_at(.funs=eval_mastery, .vars=perf_cols) %>% 
  rename(has_mastery=perf)

# Examine each performer for notHasMastery
# Inverse of the logic for hasMastery, but this might not always be the case

# Examine each performer for hasDownwardTrend
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
down_summ <- df %>% 
  group_by_at(.vars=id_cols) %>% 
  summarise_at(.funs=eval_downward, .vars=perf_cols) %>% 
  rename(has_downward=perf)

attr_table <- merge(down_summ, mastery_summ)

# Output RDF or JSON-LD annotations


