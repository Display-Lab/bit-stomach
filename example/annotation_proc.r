library(readr)
library(here)
# Parameters path to CSV and config,
#' @param data_path path to data csv file
#' @param meta_path path to csv metadata file
#' @return Annotations of performers


# All of the vars will need to be handled with quasiquotation in order to be params
# for the dplyr functions.  See:
# https://cran.r-project.org/web/packages/dplyr/vignettes/programming.html


# Name of column that ids a performer  
id_cols <- c()

# Names of columns to be analyzed for performance signals
perf_cols <- c()

# Name of column that contains time information
time_col <- c()

data_path <- file.path(here(),"example","input","data.csv")

# Read in data frame
df <- read_csv(data_path)

# Examine each performer for hasMastery

# Examine each performer for notHasMastery

# Examine each performer for hasDownwardTrend
