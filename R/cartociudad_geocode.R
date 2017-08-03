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
#' @return A data frame consisting of a single row per query. See the reference
#'   below for an explanation of the data frame columns.
#'
#' @author Carlos J. Gil Bellosta
#'
#' @references
#' \url{http://www.cartociudad.es/recursos/Documentacion_tecnica/CARTOCIUDAD_ServiciosWeb.pdf}
#'
#' @examples
#' # Query a single address
#' address <- "plaza de cascorro 11, 28005 madrid"
#' my.address <- cartociudad_geocode(full_address = address)
#' print(my.address)
#'
#' # Query multiple addresses
#' address <- c(address, "plaza del ayunamiento 1, valencia")
#' my.address <- cartociudad_geocode(full_address = address)
#' print(my.address)
#'
#' @export
#'
cartociudad_geocode <- function(full_address, output_format = "JSON") {

  stopifnot(class(full_address) == "character")
  stopifnot(length(full_address) >= 1)
  no_geocode <- which(nchar(full_address) == 0)
  res_list   <- list()

  for (i in seq_along(full_address)) {
    if (!i %in% no_geocode) {
      api.args <- list(q = full_address[i], outputformat = output_format)
      ua  <- get_cartociudad_user_agent()
      res <- httr::GET("http://www.cartociudad.es/geocoder/api/geocoder/findJsonp",
                       query = api.args, ua)
      if (httr::http_error(res)) {
        warning("Error in query ", i, ": ", httr::http_status(res)$message)
        res_list[[i]] <- data.frame(address = full_address[i],
                                    stringsAsFactors = FALSE)
      } else {
        res <- jsonp_to_json(httr::content(res, as = "text", encoding = "UTF8"))
        res <- jsonlite::fromJSON(res)
        res <- res[-which(names(res) %in% c("geom", "countryCode", "refCatastral"))]
        if (length(res) == 0) {
          warning("The query has 0 results.")
          res_list[[i]] <- data.frame(address = full_address[i],
                                      stringsAsFactors = FALSE)
        } else {
          res_list[[i]] <- as.data.frame(t(unlist(res)), stringsAsFactors = FALSE)
        }
      }
    } else {
      warning("Empty string as query: NA returned.")
      res_list[[i]] <- data.frame(address = NA, stringsAsFactors = FALSE)
    }
  }
  results <- plyr::rbind.fill(res_list)
  results[, c("lat", "lng")] <- apply(results[, c("lat", "lng")], 2, as.numeric)

  return(results)
}
