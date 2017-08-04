##########################################################################
# @gilbellosta, 2016-03-30
# Calls to Cartociudad geocoding API
##########################################################################

#' @title Interface to Cartociudad geolocation API
#'
#' @description Geolocation of Spanish addresses via Cartociudad API calls, providing the
#'   full address in a single text string via \code{full_address}. It is
#'   advisable to add the street type (calle, etc.) and to omit the country
#'   name.
#'
#' @usage cartociudad_geocode(full_address, on.error = "fail", ...)
#'
#' @param full_address Character string providing the full address to be
#'   geolocated; e.g., "calle miguel servet 5, zaragoza". Adding the country may
#'   cause problems.
#' @param on.error Defaults to \code{fail}; in such case, in case of errors in the API call, the process will fail. Set it to
#'   "warn" and, in case of errors, the function will return \code{NULL} and a warning.
#' @param ... Other parameters for the API. See Details section below.
#' 
#' @details The entity geolocation API admits more parameters beyond the address field such as \code{id} or \code{type}. 
#'   You can use these extra arguments (see the References or the Examples sections below for further information) 
#'   at your own risk.
#'
#' @return A data frame consisting of a single row per guess. See the reference
#'   below for an explanation of the data frame columns.
#'
#' @author Carlos J. Gil Bellosta
#'
#' @references
#' \url{http://www.cartociudad.es/recursos/Documentacion_tecnica/CARTOCIUDAD_ServiciosWeb.pdf}
#'
#' @examples
#' # standard usage
#' res <- cartociudad_geocode(full_address = "plaza de cascorro 11, 28005 madrid")
#' 
#' #' # km 41 of A-23 motorway
#' res <- cartociudad_geocode("A-23 41")
#' 
#' # specific usage (see References for details)
#' res <- cartociudad_geocode("A-23 41", type = "portal", id = "600000000045", portal = 41)
#' 
#' # vectorized call
#' \dontrun{
#' addresses <- paste("A-23", 1:10)
#' res <- lapply(addresses, cartociudad_geocode, on.error = "warn")
#' }
#' @export

cartociudad_geocode <- function(full_address, on.error = "fail", ...) {
    
  api.args <- c(list(q = full_address), ...)
  ua  <- get_cartociudad_user_agent()
  res <- httr::GET("http://www.cartociudad.es/geocoder/api/geocoder/findJsonp",
                   query = api.args, ua)
  
  if (httr::http_error(res)){
    if (on.error == "fail")
      stop("Call to cartociudad API failed with error code ", res$status_code)
    
    warning("Call to cartociudad API failed with error code ", res$status_code)
    return(NULL)
  }
  
  res <- jsonp_to_json(httr::content(res, as = "text", encoding = "UTF8"))
  res <- jsonlite::fromJSON(res)
  res <- as.data.frame(t(unlist(res)), stringsAsFactors = FALSE)
  
  res$lat <- as.numeric(res$lat)
  res$lng <- as.numeric(res$lng)

  res
}
