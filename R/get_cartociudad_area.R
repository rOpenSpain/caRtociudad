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
#' \dontrun{
#' get_cartociudad_area(40.3930144, -3.6596683, 500)
#' }
#'
#' @export
#'
get_cartociudad_area <- function(latitude, longitude, radius) {
  
  .Deprecated("cartociudad_get_area")
  
  cartociudad_get_area(latitude, longitude, radius)
}
