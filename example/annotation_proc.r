library(tidyr)
library(dplyr, warn.conflicts = FALSE)
library(readr)
suppressPackageStartupMessages(library(here))
library(zoo, warn.conflicts = FALSE)
library(jsonld)
suppressPackageStartupMessages(library(jsonlite))
library(stringr)

# Parameters path to CSV and config,
#' @param data_path path to data csv file
#' @param meta_path path to csv metadata file
#' @return Annotations of performers


# All of the vars will need to be handled with quasiquotation in order to be params
# for the dplyr functions.  See:
# https://cran.r-project.org/web/packages/dplyr/vignettes/programming.html

# Application ontology url.  Prefix ids with this.
app_onto_url = "https://inference.es/app/onto#"

# json-ld context structure to look up URIs from short names
uri_lookup <- list(
  "performer"       = "http://purl.obolibrary.org/obo/fio#FIO_0000001",
  "situation"       = "http://purl.obolibrary.org/obo/fio#FIO_0000050",
  "has_mastery"     = "http://purl.obolibrary.org/obo/fio#FIO_0000086",
  "has_downward"    = "http://purl.obolibrary.org/obo/fio#DownwardPerformance",
  "has_part"        = "http://purl.obolibrary.org/obo/bfo#BFO_0000051",
  "has_disposition" =  "http://purl.obolibrary.org/obo/RO_0000091",
  "client_situation" = "https://inference.es/app/onto#Client_Situation")

# Name of column that ids a performer  
id_cols <- c('id')

# Names of columns to be analyzed for performance signals
perf_cols <- c('perf')

# Name of column that contains time information
time_col <- c('time')

# Filename of input data
data_path <- file.path(here(),"example","input","data.csv")

# Output directory for json-ld
output_dir <- file.path("","tmp","bstomach")


# Read in data frame
# Sink output so that read_csv doesn't barf file names at me
sink(file=file("/dev/null","w"), type="message")
df <- read_csv(data_path)
sink(file=NULL, type="message")

# Examine each performer for disposition has_dominant_performance_capability
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

# Consolidate dispositions that have a true value 
# Rename columns for convenient export to jsonld
# Convert disposition short names like has_mastery to full url
dispositions <- full_join(down_summ, mastery_summ, id_cols) %>%
  gather(key='disposition', value="value", -id) %>%
  filter(value==T) %>%
  select(-value) %>%
  group_by(id) %>% mutate(disposition=recode(disposition, !!!uri_lookup)) 

performer_table <- dispositions %>%
  summarise(has_disposition=list(disposition)) %>%
  mutate("@type"=uri_lookup$performer, id=paste0(app_onto_url,id)) %>%
  rename("@id"=id, !!uri_lookup$has_disposition := has_disposition)

# make JSON-LD from data annotations
# Build a context that maps the attribute table column names to canonnical URIs
## IDs need to be URIs.  Add these to the application ontology?
ctx <- toJSON(uri_lookup, auto_unbox = T)

doc <- paste('{"@id":"https://inference.es/app/onto#Client_Situation",',
      '"@type":"http://purl.obolibrary.org/obo/fio#FIO_0000050",',
      '"http://purl.obolibrary.org/obo/bfo#BFO_0000051":', toJSON(performer_table), '}')


full <- list("@context"=uri_lookup,
             "@id"=uri_lookup$client_situation,
             "@type"= uri_lookup$situation,
             "has_part"=performer_table)

# Expand and compact json document to fill in the 
f <- toJSON(full, auto_unbox = T, pretty = T)
e <- jsonld_expand(f)
json_output <- jsonld_compact(e, toJSON(uri_lookup,auto_unbox = T))


# Write to file and output filename to std out
dir.create(output_dir, showWarnings=F)
tmp_filename <- tempfile(pattern="situation", tmpdir=output_dir, fileext=".json")

cat(json_output, file=tmp_filename)
cat(tmp_filename)
