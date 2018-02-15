# write json to destination directory

persist_to_disk <- function(content, output_dir=tempdir() ){
  
  # Make output directory if it doesn't already exist
  dir.create(output_dir, showWarnings=F)
  tmp_filename <- tempfile(pattern="situation", tmpdir=output_dir, fileext=".json")
  
  cat(content, file=tmp_filename)
  cat(tmp_filename)
  
}