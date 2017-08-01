##########################################################################
# Luz Frias, 2016-06-03
# Common util functions
##########################################################################

get_cartociudad_user_agent <- function() {
  ua <- paste0("caRtociudad/", utils::packageVersion("caRtociudad"),
               " (https://github.com/cjgb/caRtociudad)")
  return(httr::user_agent(ua))
}

jsonp_to_json <- function(text) {
  text <- gsub("^\\w+\\(", "", text)
  text <- gsub("\\)$", "", text)
  return(text)
}

rbind_lists_df <- function(x, y) {
  x_diff <- setdiff(colnames(x), colnames(y))
  y_diff <- setdiff(colnames(y), colnames(x))
  x[, c(as.character(y_diff))] <- NA
  y[, c(as.character(x_diff))] <- NA
  return(rbind(x, y))
}
