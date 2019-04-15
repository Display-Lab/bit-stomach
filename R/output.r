#' @title Output
#' @description Persist json to disk
#' @param content json content
#' @param outpath path to write output or "" for standard output
#' @importFrom methods is
#' @importFrom rlang abort
output <- function(content, outpath = "") {
  # If passed a path, attempt to open it
  if(!identical(outpath, "")){
    out <- file(outfile, "wt")
    if(!isOpen(outfile, "w")){ rlang::abort("Output file is not writeble.") }
  }else{
    out = outpath
  }

  # Write content and do not circumvent sink()
  cat(content, out)

  return(TRUE)
}
