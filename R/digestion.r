#' @title Digestion
#' @description Digest the inputs specified in the runtime configuration.
#' @param annotation_path path to annotations.r file
#' @param raw_data data frame of performance data as read from disk
#' @param spek Lists representation of spek graph
#' @return table of performers and their annotations
#' @importFrom spekex get_id_col_from_spek
#' @importFrom purrr lmap
digestion <- function(annotation_path, raw_data, spek){
  # Source annotation functions and additional uri lookup
  anno_env <- source_annotations(annotation_path)

  # Canonicalize id columns to single id column.
  id_columns <- spekex::get_id_col_from_spek(spek)
  idd_data <- canonicalize_ids(raw_data, id_columns)

  # Split data by measure
  m_data <- split_by_measure(idd_data, spek)

  # Process each measure through annotations
  m_performers <- purrr::lmap(.x=m_data, .f=measure_digest, spek=spek, anno_env=anno_env)

  # Aggregate each measure-performers table under single performer
  make_performers(m_performers)
}

#' @title Make Performers
#' @description Create table of performers from measure-performers
#' @param m_performers List of measure-performer tibbles
#' @importFrom dplyr bind_rows
make_performers <- function(m_performers){
  df <- dplyr::bind_rows(m_performers)
  df %>%
    group_by(`@id`) %>%
    summarise_at(.vars=BS$HAS_DISPOSITION_URI, .funs=aggregate_measure_dispositions) %>%
    mutate("@type" = BS$PERFORMER_URI, `@id` = paste0(BS$DEFAULT_APP_ONTO_URL, `@id`))
}

#' @title Aggregate Measure Dispositions
#' @describeIn digestion Helper function to collapse lists of measure-dispositions to single list.
#' @param List of lists of measure-dipositions
#' @importFrom purrr reduce
aggregate_measure_dispositions <- function(x){
  result <- purrr::reduce(x, append)
  list(result)
}

#' @title Measure Digest
#' @describeIn digestion Generate annotations about a single measure.
#' @param ldata named sub list of measure data. Essentially m_data[n]
#' @param spek Lists representation of spek graph
#' @param anno_env Environment containing annotation functions
measure_digest <- function(ldata, spek, anno_env){
  data <- ldata[[1]]
  measure_id <- names(ldata)

  # Process data and generate annotations
  annotations <- annotate(data, anno_env, spek)
  if(Sys.getenv("BS_VERBOSE") == T){ print(annotations)}

  # URI Substitute annotations
  uri_annotations <- swap_in_uris(annotations, BS$DEFAULT_URI_LOOKUP)

  # Filter annotations to get dispositions
  dispositions <- distill_annotations(uri_annotations)
  if(Sys.getenv("BS_VERBOSE") == T){ print(dispositions)}

  # Create performers table as precursor to json-ification
  perf_dispositions <- performers(dispositions)

  old_disps <- perf_dispositions[[BS$HAS_DISPOSITION_URI]]
  updated_disps <- lapply(old_disps, add_measure_to_disposition, m_id=measure_id)
  perf_dispositions[[BS$HAS_DISPOSITION_URI]] <- updated_disps

  # Wrap tibble in a list to fit return type of lmap
  return(list(perf_dispositions))
}

#' @title Structure Disposition
#' @description Create structure relating disposition to measure
#' @param disposition List dispostion IRIs of the performer each the IRI of a class of information content entity
#' @param m_id The @id of the measure
#' @return data frame wrapped in a list. Structured representation of the information content entity
add_measure_to_disposition <- function(disposition, m_id){
  disposition[[1]][BS$REGARDING_MEASURE] <- m_id
  return(disposition)
}
