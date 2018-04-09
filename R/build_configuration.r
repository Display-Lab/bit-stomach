#' @title Build Configuration
#' @description Build runtime configuration by reading configuration from path or use defaults.
#' @import config
#' @importFrom here here
build_configuration <- function(path_to_config) {
  list(
    uri_lookup = BS$DEFAULT_URI_LOOKUP,
    app_onto_url = "https://inference.es/app/onto#",
    data_path = system.path(c("example", "input", "performer-data.csv"), package = "bitstomach", mustWork = T),
    output_dir = file.path("", "tmp", "bstomach"),
    annotation_path = system.path(c("example", "input", "annotations.r"), package = "bitstomach", mustWork = T),
    id_cols = c("performer"),
    perf_cols = c("score"),
    time_col = c("timepoint")
  )
}
