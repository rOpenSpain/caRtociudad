##########################################################################
# Luz Frias, 2016-04-26
# Calculates the area given a point and a radius
##########################################################################

get_cartociudad_area <- function(latitude, longitude, radius) {
  query.parms <- list(
    lat = latitude,
    lon = longitude,
    dist = radius
  )
  
  url <- "http://www.cartociudad.es/services/api/serviceArea"
  ua <- get_cartociudad_user_agent()
  
  res <- GET(url, query = query.parms, ua)
  stop_for_status(res)
  info <- content(res)
  
  # Parse the response
  polygon <- info$coordinates
  if (!is.null(polygon)) {
    result <- data.frame(matrix(unlist(polygon), nrow = length(polygon[[1]]), byrow = TRUE))
    colnames(result) <- c("longitude", "latitude")
  } else {
    result <- data.frame(latitude = numeric(0), longitude = numeric(0))
  }
  
  result
}