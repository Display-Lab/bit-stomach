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
build_configuration <- function(config_path, ...) {
  default_config()
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
