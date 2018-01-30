# Cannonicalize IDs

canonicalize_ids <- function(data, id_cols){
  id_syms <- rlang::syms(id_cols)
  df %>% 
    mutate(id=paste(!!!id_syms, sep='-')) %>%
    select(-c(!!!id_syms))
}