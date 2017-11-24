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

get_ntries <- function(url, query, ua, tries) {
  withRestarts(
    tryCatch(httr::GET(url, query = query, ua),
             error = function(e) {invokeRestart("retry")}),
    retry = function() {
      message("Failing to connect with server: retrying...")
      if (tries < 0) {
        stop("Failing to connect with server: connection timed out, try later.")
      }
      Sys.sleep(5)
      get_ntries(url, query, ua, tries - 1)
    }
  )
}
