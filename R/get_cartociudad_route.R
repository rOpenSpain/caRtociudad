##########################################################################
# @gilbellosta, 2016-03-30
# Gets routes between two points
##########################################################################

#' @title Driving and walking directions from Cartociudad API
#'
#' @description Cartociudad API provides driving and walking routes between two
#'   points. This function quieries the API and provides the user the data in
#'   convenient form.
#'
#' @param latlon.orig Latitude and longitude of the starting point
#' @param latlon.dest Latitude and longitude of the destination point
#' @param vehicle Either \code{car} or \code{walking}
#'
#' @return A list containing the fields described in Cartociudad API
#'   documentation (see the link below).
#'
#' @author Carlos J. Gil Bellosta
#'
#' @references
#' \url{http://www.cartociudad.es/recursos/Documentacion_tecnica/CARTOCIUDAD_ServiciosWeb.pdf}
#'
#' @usage get_cartociudad_route(latlon.orig, latlon.dest, vehicle = "car")
#'
#' @examples
#' \dontrun{
#' res <- get_cartociudad_route(c(39.48,-0.37),
#'    c(39.484336,-0.358171),
#'    vehicle = "car")
#' }
#' 
#' @export
#'
get_cartociudad_route <- function(latlon.orig, latlon.dest, vehicle = "car"){
  .Deprecated("cartociudad_get_route")
  cartociudad_get_route(latlon.orig, latlon.dest, vehicle)
}
