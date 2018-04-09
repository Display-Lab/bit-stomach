#' @title Cannonicalize Ids
#' @import dplyr
#' @description Concatenate id column values into single id column. 
canonicalize_ids <- function(data, id_cols){
  id_syms <- rlang::syms(id_cols)
  data %>% 
    mutate(id=paste(!!!id_syms, sep='-')) %>%
    select(-c(!!!id_syms))
}