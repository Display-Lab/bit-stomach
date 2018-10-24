#' @title Build Configuration
#' @description Build runtime configuration by reading configuration from path or use defaults.
#' @param config_path Path to configuration yaml. Use NULL to use internal defaults.
#' @param ... List of configuration overrides
#' @return a configuration
#' @note The list of overrides can include any values in the config:
#'    app_onto_url
#'    data_path
#'    output_dir
#'    annotation_path
#'    id_cols
#'    perf_cols
#'    time_col
#'    verbose
#' @import config
#' @importFrom here here
#' @importFrom utils modifyList
build_configuration <- function(config_path=NULL, ...) {
  # Start with default config
  d_config <- default_config()

  # Read from config if supplied
  if(is.null(config_path)){
    r_config <- list()
  }else{
    r_config <- tryCatch(config::get(file = config_path, use_parent = F),
                         error=cfg_file_error )
  }

  # Merge & overwrite default (d) config with read (r) config
  dr_config <- utils::modifyList(d_config, r_config)

  # Merge parameter (p) config overrides from dots parameters.
  p_config <- list(...)
  drp_config <- utils::modifyList(dr_config, p_config)

  return(drp_config)
}

#' @title Default Configuration
#' @description Provide default configuration values
#' @describeIn Build Configuration
default_config <- function(){
  list(
    app_onto_url = BS$DEFAULT_APP_ONTO_URL,
    data_path = system.file("example", "basic", "performer-data.csv", package = "bitstomach", mustWork = T),
    outfile = BS$DEFAULT_OUTFILE,
    annotation_path = system.file("example", "basic", "annotations.r", package = "bitstomach", mustWork = T),
    uri_lookup = BS$DEFAULT_URI_LOOKUP,
    col_spec = BS$DEFAULT_COL_SPEC,
    verbose = BS$DEFAULT_VERBOSE
  )
}

#' @title Config File Error
#' @description Emit warning and return empty list in event of error reading config file
#' @importFrom rlang warn
cfg_file_error <- function(e){
  msg <- paste("Problem reading config file:", e$message, sep="\n  ")
  rlang::warn(msg)
  return(list())
}
