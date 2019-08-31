# Setup integration test switch

#Default to FULLTEST being true
if(is.na( Sys.getenv("FULLTEST",unset=NA))) { Sys.setenv("FULLTEST"=TRUE) }

#Default to BS_VERBOSE being FALSE
if(is.na( Sys.getenv("FULLTEST",unset=NA))) { Sys.setenv("BS_VERBOSE"=FALSE) }
