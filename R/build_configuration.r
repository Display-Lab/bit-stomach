#' @title Build Configuration
#' @description Build runtime configuration by reading configuration from path or use defaults.
#' @param config_path Path to configuration yaml. Use NULL to use internal defaults.
#' @param ... List of configuration overrides
#' @return a configuration
#' @note The list of overrides can include any values in the config:
#'    uri_lookup
#'    app_onto_url
#'    data_path
#'    output_dir
#'    annotation_path
#'    id_cols
#'    perf_cols
#'    time_col
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

  # Merge & overwrite
  dr_config <- utils::modifyList(d_config, r_config)

  # Overrides from dots.
  p_config <- list(...)
  drp_config <- utils::modifyList(dr_config, p_config)

  return(drp_config)
}

#' @title Default Configuration
#' @description Provide default configuration values
default_config <- function(){
  list(
    uri_lookup = BS$DEFAULT_URI_LOOKUP,
    app_onto_url = "https://inference.es/app/onto#",
    data_path = system.file("example", "basic", "performer-data.csv", package = "bitstomach", mustWork = T),
    output_dir = tempdir(),
    annotation_path = system.file("example", "basic", "annotations.r", package = "bitstomach", mustWork = T),
    col_spec = list(
      id_cols = c("performer"),
      perf_cols = c("score"),
      ordering_cols = c("timepoint")
    )
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
