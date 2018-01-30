
# Filter for annoatations that have a true value 
# Rename columns for convenient export to jsonld
# Convert annotation short names like has_mastery to full url
distill_annotations <- function(annotations, uri_lookup){
  annotations %>%
    gather(key='disposition', value="value", -id) %>%
    filter(value==T) %>%
    select(-value) %>%
    group_by(id) %>%
    mutate(disposition=recode(disposition, !!!uri_lookup)) 
}
