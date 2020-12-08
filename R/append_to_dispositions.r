#' @title Append to Dispositions
#' @param disps_tbl Tibble or data frame with id and list of dispositions.
#' @param predicate fully qualified URI of predicate to add to each disposition.
#' @param object the object of the predicate to add to each disposition. e.g list(list(`@id`=measure_id))
#' @description Add predicate object to each disposition of each performer in a dispositions table.
#' @return Updated dispositions table
append_to_dispositions<- function(disps_tbl, predicate, object){
  disps_tbl[[BS$HAS_DISPOSITION_URI]] <- lapply(X = disps_tbl[[BS$HAS_DISPOSITION_URI]],
                                                FUN = add_predicate_to_dispositions,
                                                predicate = predicate, object = object)
  disps_tbl
}

#' Add Predicate to Dispositions
#' @describeIn Append to Dispositions
#' @description Apply predicate to list of lists of dispositions
add_predicate_to_dispositions <- function(disps_list, predicate, object){
  lapply(disps_list, attach_predicate, predicate=predicate, object=object)
}

#' Attach Predicate
#' @describeIn Append to Dispositions
#' @description Add predicate and object to single disposition
#' @param object list wrapped value for the predicate. e.g. list(list(`@id`=measure_id))
attach_predicate <- function(disp, predicate, object){
  disp[predicate] <- object
  return(disp)
}
