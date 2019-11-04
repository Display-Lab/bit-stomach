#' @title Main
#' @description The entry function with all the side effects.
#' @param spek_path Path to spek json.
#' @param annotation_path Path to file to source annotations from.
#' @param data_path Path to file to csv from which to read data.
#' @param verbose Boolean answering, "should debugging info be printed to stderr?"
#' @importFrom spekex write_spek read_spek
#' @export
main <- function(spek_path = NULL, annotation_path, data_path, verbose=FALSE) {
  # Set verbose env flag
  if(verbose){
    Sys.setenv(BS_VERBOSE=TRUE)
  } else{
    Sys.setenv(BS_VERBOSE=FALSE)
  }

  # Read inputs
  spek <- spekex::read_spek(spek_path)
  col_types <- spekex::cols_for_readr(spek)
  raw_data <- read_data(data_path, col_types)

  # Process performance data and annotate performers
  performers_table <- digestion(annotation_path, raw_data, spek)

  # Merge performer annotations into the spek
  spek_plus <- merge_performers(spek, performers_table)

  # Write spek to stdout
  spekex::write_spek(spek_plus)
  invisible(NULL)
}
