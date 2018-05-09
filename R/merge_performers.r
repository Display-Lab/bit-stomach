#' @title Merge Performers
#' @description Apply annotations to performers in spek.
#' @details Adds newly found performers and updates esiting performers in spek
#' @import jsonlite

merge_performers <- function(spek, performers_table){

  pt_list <- jsonlite::fromJSON(jsonlite::toJSON(performers_table), simplifyDataFrame = F, simplifyVector = T)
  spek_performers <- spek[[BS$HAS_PERFORMERS_URI]]

  # Get vectors of @id elements
  p_ids <- sapply(pt_list, getElement, name="@id" )
  s_ids <- sapply(spek_performers, getElement, name="@id" )

  # update names of performers table for access by @id
  names(pt_list) <- p_ids

  # Update the performers from the spek
  sp_updated <- lapply(spek_performers, FUN=update_performer, annotated_performers=pt_list)

  # append non-shared performers

  # update shared ids
  matching_idxs <- match(p_ids, s_ids, nomatch=NULL)
  matching_idxs <- m_idxs[!is.na(m_idxs)]

  sp_merged <- c(sp_updated, pt_list[-matching_idxs], use.names=FALSE)

  # Update performers section of spek
  spek_plus <- spek
  spek_plus[[BS$HAS_PERFORMERS_URI]] <- sp_merged

  return(spek_plus)
}

update_performer <- function(sp, annotated_performers){
  ap <- annotated_performers[[sp$`@id`]]
  if(is.null(ap)){
    return(sp)
  } else {
    mundify_list(sp, ap)
  }
}

# Modify list and murge unnamed values
mundify_list <- function (x, val, keep.null = FALSE)
{
  stopifnot(is.list(x), is.list(val))
  xnames <- names(x)
  vnames <- names(val)
  vnames_idx <- which(nzchar(vnames))
  vnames <- vnames[nzchar(vnames)]

  # go through named values
  for (v in vnames) {
    x[[v]] <- if (v %in% xnames && is.list(x[[v]]) && is.list(val[[v]])){
      mundify_list(x[[v]], val[[v]])
    }
    else{
      val[[v]]
    }
  }

  # also append unnamed values
  if(is.null(vnames)){
    values <- val
  }else{
    values <- val[-vnames_idx]
  }

  for (value in values){
    value_exists_in_x <- any(sapply(x,identical,value))
    if(!value_exists_in_x){
      x[[length(x)+1]] <- value
    }
  }

  return(x)
}
