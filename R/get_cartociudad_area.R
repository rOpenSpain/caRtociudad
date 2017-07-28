##########################################################################
# Luz Frias, 2016-04-26
# Calculates the area given a point and a radius
##########################################################################

#' @title Area calculation
#'
#' @description Returns the polygon that describes the area
#'
#' @details This function calculates the area given a point and a radius in
#'   meters
#'
#' @usage get_cartociudad_area(latitude, longitude, radius)
#'
#' @param latitude Point latitude in geographical coordinates (e.g., 40.3930144)
#' @param longitude Point longitude in geographical coordinates (e.g.,
#'   -3.6596683)
#' @param radius Distance in meters (e.g., 500)
#'
#' @return A dataframe with the polygon that describes the area.
#'
#' @author Luz Frias
#'
#' @references
#' \url{http://www.cartociudad.es/recursos/Documentacion_tecnica/CARTOCIUDAD_ServiciosWeb.pdf}
#'
#' @examples
#' get_cartociudad_area(40.3930144, -3.6596683, 500)
#'
#' @export
#'
get_cartociudad_area <- function(latitude, longitude, radius) {
  query.parms <- list(
    lat = latitude,
    lon = longitude,
    dist = radius
  )

  url <- "http://www.cartociudad.es/services/api/serviceArea"
  ua <- get_cartociudad_user_agent()
  res <- httr::GET(url, query = query.parms, ua)
  httr::stop_for_status(res)
  info <- httr::content(res)

  # Parse the response
  polygon <- info$coordinates
  if (!is.null(polygon)) {
    result <- data.frame(matrix(unlist(polygon), nrow = length(polygon[[1]]), byrow = TRUE))
    colnames(result) <- c("longitude", "latitude")
  } else {
    result <- data.frame(latitude = numeric(0), longitude = numeric(0))
  }
  return(result)
}
