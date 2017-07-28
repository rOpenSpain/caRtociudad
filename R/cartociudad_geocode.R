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
#' @usage cartociudad_geocode(full_address, output_format = "JSON")
#'
#' @param full_address Character string providing the full address to be
#'   geolocated; e.g., "calle miguel servet 5, zaragoza". Adding the country may
#'   cause problems.
#' @param output_format Character string. Output format of the query: "JSON" or
#'   "GeoJSON".
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
#' # using full address
#' my.address <- cartociudad_geocode(full_address = "plaza de cascorro 11, 28005 madrid")
#' print(my.address)
#'
#' @export
#'
cartociudad_geocode <- function(full_address, output_format = "JSON") {
    api.args <- list(q = full_address, outputformat = output_format)
    ua  <- get_cartociudad_user_agent()
    res <- httr::GET("http://www.cartociudad.es/geocoder/api/geocoder/findJsonp",
                     query = api.args, ua)
    httr::stop_for_status(res)

    res <- jsonp_to_json(httr::content(res, as = "text", encoding = "UTF8"))
    res <- jsonlite::fromJSON(res)
    res <- as.data.frame(t(unlist(res)), stringsAsFactors = FALSE)
    res[, c(grep("lat", names(res)), grep("lng", names(res)))] <-
      apply(res[, c(grep("lat", names(res)), grep("lng", names(res)))], 2, as.numeric)
    return(res)
}
