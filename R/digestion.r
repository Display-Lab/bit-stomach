#' @title Digestion
#' @description Cuts up the input by measure, processes each measure, and consolidates results.
#' @param annotation_path path to annotations.r file
#' @param raw_data data frame of performance data as read from disk
#' @param spek Lists representation of spek graph
#' @return table of performers and their annotations
#' @importFrom spekex get_id_col_from_spek
#' @importFrom purrr lmap
# RETURN EXAMPLE:
#   A tibble:
#   `@id`   `http://purl.obolibrary.org/obo/RO_0000091` `@type`
#   <chr>   <list>                                      <chr>
#   1 _:p1156 <list [16]>                                 http://purl.obolibrary.org/obo/psdo_0000085
#   2 _:p802  <list [14]>                                 http://purl.obolibrary.org/obo/psdo_0000085
#   3 _:pSyn1 <list [10]>                                 http://purl.obolibrary.org/obo/psdo_0000085
#   4 _:pSyn2 <list [2]>                                  http://purl.obolibrary.org/obo/psdo_0000085
# Single entry of one of the R0_0000091 list
#   [[1]]
#   [[1]]$`@type`: "http://purl.obolibrary.org/obo/psdo_0000094"
#   [[1]]$`http://example.com/slowmo#RegardingComparator`$`@id`: "_:m1002"
#   [[1]]$`http://example.com/slowmo#RegardingMeasure`$`@id`: "_:m3"
digestion <- function(annotation_path, raw_data, spek){
  # Source annotation functions and additional uri lookup
  anno_env <- source_annotations(annotation_path)

  # Canonicalize id columns to single id column.
  id_columns <- spekex::get_id_col_from_spek(spek)
  idd_data <- canonicalize_ids(raw_data, id_columns)

  # Split data by measure
  measure_data <- split_by_measure(idd_data, spek)

  # Process each measure through annotations
  dispositions <- purrr::lmap(.x=measure_data, .f=multiple_digest,
                              spek=spek, anno_env=anno_env)

  # Aggregate each measure-performers table under single performer
  make_performers(dispositions)
}
