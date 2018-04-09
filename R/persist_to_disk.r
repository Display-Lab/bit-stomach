#' @title Persist to Disk
#' @description Persist json to disk
#' @param content json content
#' @param output_dir directory to create and write output into
persist_to_disk <- function(content, output_dir=tempdir()) {

  # Make output directory if it doesn't already exist
  dir.create(output_dir, showWarnings = F)
  tmp_filename <- tempfile(pattern = "situation", tmpdir = output_dir, fileext = ".json")

  cat(content, file = tmp_filename)
  cat(tmp_filename)
}
