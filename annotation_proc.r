library(tidyr)
library(dplyr, warn.conflicts = FALSE)
library(readr)
suppressPackageStartupMessages(library(here))
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


# default URIs used in json-ld context.
# structure to look up URIs from short names of column headings
default_uri_lookup <- list(
  "performer"       = "http://purl.obolibrary.org/obo/fio#FIO_0000001",
  "situation"       = "http://purl.obolibrary.org/obo/fio#FIO_0000050",
  "has_part"        = "http://purl.obolibrary.org/obo/bfo#BFO_0000051",
  "has_disposition" =  "http://purl.obolibrary.org/obo/RO_0000091",
  "client_situation" = "https://inference.es/app/onto#Client_Situation")

# TODO: Read from configuration eventually.  In the meantime, hardcode!
# Name of column that ids a performer  
id_cols <- c('performer')
# Names of columns to be analyzed for performance signals
perf_cols <- c('score')
# Name of column that contains time information
time_col <- c('timepoint')

# TODO: Read from path to data from CLI eventually.  In the meantime, hardcode!
# Filename of input data
data_path <- file.path(here(),"example","input","performer-data.csv")
# Output directory for json-ld
output_dir <- file.path("","tmp","bstomach")

# TODO: Read annotation function file from CLI eventually. Hardcode for now.
annotation_path <- file.path(here(),"example","input","annotations.r")

# Source the annotations for the situation into anno env.
# Get all functions that start with annotation_
# Add the uri_lookup from anno env to default list of uri lookups
anno_env <- new.env(parent=.BaseNamespaceEnv)
source(annotation_path, local=anno_env)

# Merge any uri_lookup in the annotation with the default
uri_lookup <- c(default_uri_lookup , anno_env$uri_lookup)


# Read in data frame
# Sink output so that read_csv doesn't barf file names at me
sink(file=file("/dev/null","w"), type="message")
df <- read_csv(data_path)
sink(file=NULL, type="message")

# Convert the id columns to a single column by concatenation
id_syms <- rlang::syms(id_cols)
df <- df %>% 
  mutate(id=paste(!!!id_syms, sep='-')) %>%
  select(-c(!!!id_syms))
  
# Examine each performer for disposition has_dominant_performance_capability
# TODO: Run through the list of the annotation functions in the annotator env.
#  Get list of results data frames.
#  Left join them all

afs <- lsf.str(envir=anno_env, pattern="annotate")
anno_args <- list(data=df, perf_cols=perf_cols)

# Create an annotation table per each annotation function
anno_results <- lapply(afs, do.call, args=anno_args, envir=anno_env)

# Reduce results list into a single annotation table
annotations <- Reduce(left_join, anno_results)

# Filter for annoatations that have a true value 
# Rename columns for convenient export to jsonld
# Convert annotation short names like has_mastery to full url
dispositions <- annotations %>%
  gather(key='disposition', value="value", -id) %>%
  filter(value==T) %>%
  select(-value) %>%
  group_by(id) %>%
  mutate(disposition=recode(disposition, !!!uri_lookup)) 
  
# Condense to table with single row per performer and list of their annoations
#  Convenient format for export to JSON-LD
performer_table <- dispositions %>%
  summarise(has_disposition=list(disposition)) %>%
  mutate("@type"=uri_lookup$performer, id=paste0(app_onto_url,id))  %>%
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

