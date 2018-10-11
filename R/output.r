#' @title Output
#' @description Persist json to disk
#' @param content json content
#' @param outfile path or conn to write output to
#' @importFrom methods is
output <- function(content, outfile) {
  # If passed a path, attempt to open it
  if(is.character(outfile)){ outfile <- file(outfile, "wt") }

  # Check that connection is open and writable
  if(is(outfile, "connection") && isOpen(outfile, "w")){
    out <- outfile
  } else {
    return(FALSE)
  }

  # Write content
  cat(content, file = out)

  # Return success
  return(TRUE)
}
