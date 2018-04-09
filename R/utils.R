##########################################################################
# Luz Frias, Carlos Gil Bellosta 2016-06-03
# Common util functions
##########################################################################

get_cartociudad_user_agent <- function() {
  ua <- paste0("caRtociudad/", utils::packageVersion("caRtociudad"),
               " (https://github.com/rOpenSpain/caRtociudad)")
  return(httr::user_agent(ua))
}

jsonp_to_json <- function(text) {
  text <- gsub("^\\w+\\(", "", text)
  text <- gsub("\\)$", "", text)
  return(text)
}

overlay_wms_map <- function(map, url, query) {
  ua <- get_cartociudad_user_agent()
  res <- httr::GET(url, query = query, ua)
  httr::warn_for_status(res) # data may not be available at a given map resolution
  map <- tryCatch({
    cs.layer <- httr::content(res, as = "parsed", type = "image/png")
    # png overlay taking transparency into account
    # note that cs layer has transparency 0/1
    
    mask <- array(cs.layer[, , 4], dim(cs.layer))
    (1 - mask) * map + mask * cs.layer
  },
  error = function(x) return(map),  # we have already warned
  warning = function(x) return(map) # ditto
  )
}
