#' @title Main
#' @description The entry function with all the side effects.
#' @param spek_path Path to spek json.
#' @param annotation_path Path to file to source annotations from.
#' @param data_path Path to file to csv from which to read data.
#' @param verbose Boolean answering, "should debugging info be printed to stderr?"
#' @importFrom spekex write_spek read_spek
#' @export
main <- function(spek_path = NULL, annotation_path, data_path, verbose=FALSE) {
  # Read inputs
  spek <- spekex::read_spek(spek_path)
  raw_data <- read_data(data_path)

  # Build configuration
  if(verbose){ Sys.setenv(BS_VERBOSE=TRUE) }
  else{ Sys.setenv(BS_VERBOSE=FALSE) }

  # Ingest performance data and annotate performers based on performance data
  performers_table <- digestion(annotation_path, raw_data, spek)

  # Merge performer annotations with given spek
  spek_plus <- merge_performers(spek, performers_table)

  # Write Spek with annotations added to outfile
  spekex::write_spek(spek_plus)
  invisible(NULL)
}
