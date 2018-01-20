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
#' @usage cartociudad_reverse_geocode(latitude, longitude, ntries = 10)
#'
#' @param latitude Point latitude in geographical coordinates (e.g., 40.473219)
#' @param longitude Point longitude in geographical coordinates (e.g.,
#'   -3.7227241)
#' @param ntries Numeric. In case of connection failure, number of \code{GET}
#'   requests to be made before stopping the function call.
#'
#' @return A data frame consisting of a single row per query, with columns:
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
#' # Query one point
#' cartociudad_reverse_geocode(40.473219, -3.7227241)
#'
#' # Query multiple points
#' cartociudad_reverse_geocode(c(40.473219, 39.46979), c(-3.7227241, -0.376963))
#'
#' @export
#'
cartociudad_reverse_geocode <- function(latitude, longitude, ntries = 1) {

  stopifnot(length(latitude) == length(longitude) | length(latitude) == 0)

  res_list  <- list()
  url       <- "http://www.cartociudad.es/services/api/geocoder/reverseGeocode"
  ua        <- get_cartociudad_user_agent()
  no_select <- c("geom", "poblacion", "stateMsg", "state", "priority", "countryCode")
  total      <- length(latitude)
  pb         <- utils::txtProgressBar(min = 0, max = total, style = 3)

  for (i in seq_len(total)) {
    query.parms <- list(lat = latitude[i], lon = longitude[i])
    res         <- get_ntries(url, query.parms, ua, ntries)
    if (httr::http_error(res)) {
      warning("Error in query ", i, ": ", httr::http_status(res)$message)
      res_list[[i]] <- data.frame(lat = latitude[i], lng = longitude[i],
                                  stringsAsFactors = FALSE)
    } else if (length(httr::content(res)) == 0) {
      warning("Query ", i, " produced 0 results.")
      res_list[[i]] <- data.frame(lat = latitude[i], lng = longitude[i],
                                  stringsAsFactors = FALSE)
    } else {
      info          <- httr::content(res)
      info          <- info[-which(names(info) %in% no_select)]
      res_list[[i]] <- as.data.frame(t(unlist(info)), stringsAsFactors = FALSE)
    }
    utils::setTxtProgressBar(pb, i)
  }

  cat("\n")
  results <- plyr::rbind.fill(res_list)
  names_old <- c("type", "tip_via", "address", "portalNumber", "id",
                 "muni", "province", "postalCode", "lat", "lng")
  names_new <- c("tipo", "tipo.via", "nombre.via", "num.via", "num.via.id",
                 "municipio", "provincia", "cod.postal", "lat", "lng")
  for (i in seq_len(ncol(results))) {
    colnames(results)[colnames(results) == names_old[i]] <- names_new[i]
  }

  return(results)
}
