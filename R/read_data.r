# Read in data frame
read_data <- function(data_path){
  # Sink output so that read_csv doesn't barf file names at me
  sink(file=file("/dev/null","w"), type="message")
  df <- read_csv(data_path)
  sink(file=NULL, type="message")
}
