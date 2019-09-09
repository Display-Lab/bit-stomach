# Setup integration test switch

# Default to FULLTEST being true
if(is.na( Sys.getenv("FULLTEST",unset=NA))) { Sys.setenv("FULLTEST"=TRUE) }
# Sys.setenv(FULLTEST=FALSE) # Use this line to disable fulltest

# Default to BS_VERBOSE being FALSE
if(is.na( Sys.getenv("BS_VERBOSE",unset=NA))) { Sys.setenv("BS_VERBOSE"=FALSE) }
# Sys.setenv(BS_VERBOSE=TRUE) # Use this line to enable verbose
