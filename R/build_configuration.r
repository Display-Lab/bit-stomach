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
build_configuration <- function(spek, ...) {
  # Start with default config
  d_config <- BS$DEFAULT_RUN_CONFIG

  # Merge parameter (p) config overrides from dots parameters.
  p_config <- list(...)
  dp_config <- utils::modifyList(d_config, p_config)

  return(dp_config)
}
