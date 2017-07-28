##########################################################################
# Luz Frias, 2016-04-26
# Reverse geocoding of a location using cartociudad API
##########################################################################

#' @title Reverse geocoding of locations
#'
#' @description Returns the address details of a geographical point in Spain.
#'
#' @details This function performs reverse geocoding of a location. It returns
#'   the details of the closest address in Spain.
#'
#' @usage cartociudad_reverse_geocode(latitude, longitude)
#'
#' @param latitude Point latitude in geographical coordinates (e.g., 40.473219)
#' @param longitude Point longitude in geographical coordinates (e.g.,
#'   -3.7227241)
#'
#' @return A list with the following items:
#' \item{tipo}{type of location.}
#' \item{tipo.via}{road type.}
#' \item{nombre.via}{road name.}
#' \item{num.via}{road number.}
#' \item{num.via.id}{internal id of this address in cartociudad database.}
#' \item{municipio}{town.}
#' \item{provincia}{province.}
#' \item{cod.postal}{zip code.}
#'
#' @author Luz Frias
#'
#' @references
#' \url{http://www.cartociudad.es/recursos/Documentacion_tecnica/CARTOCIUDAD_ServiciosWeb.pdf}
#'
#' @examples
#' cartociudad_reverse_geocode(40.473219, -3.7227241)
#'
#' @export
#'
cartociudad_reverse_geocode <- function(latitude, longitude) {
  
  query.parms <- list(
    lat = latitude,
    lon = longitude
  )
  
  url <- "http://www.cartociudad.es/services/api/geocoder/reverseGeocode"
  ua <- get_cartociudad_user_agent()
  
  
  res <- httr::GET(url, query = query.parms, ua)
  httr::stop_for_status(res)
  info <- httr::content(res)
  # Parse the response
  res <- list(
    tipo       = info$type,
    tipo.via   = info$tip_via,
    nombre.via = info$address,
    num.via    = info$portalNumber,
    num.via.id = info$id,
    municipio  = info$muni,
    provincia  = info$province,
    cod.postal = info$postalCode
  )
  return(res)
}
