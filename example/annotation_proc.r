library(dplyr, warn.conflicts = FALSE)
library(readr)
library(here)
library(zoo)

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
df %>% 
  group_by_at(.vars=c('id')) %>% 
  summarise_at(.funs=eval_mastery, .vars=c('perf')) %>% 
  rename(has_mastery=perf)

# Examine each performer for notHasMastery
# Inverse of the logic for hasMastery, but this might not always be the case

# Examine each performer for hasDownwardTrend
