# Source the annotations for the situation into anno env.
source_annotations <- function(path){
  anno_env <- new.env(parent=.BaseNamespaceEnv)
  source(path, local=anno_env)
  return(anno_env)
}