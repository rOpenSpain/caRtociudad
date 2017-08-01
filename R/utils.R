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
