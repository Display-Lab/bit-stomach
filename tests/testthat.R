library(testthat)
library(bitstomach)
library(utils)

#Default to FULLTEST being true
if(is.na( Sys.getenv("FULLTEST",unset=NA))) {
  Sys.setenv("FULLTEST"=TRUE)
  }

test_check("bitstomach")
