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
#' @return A data frame consisting of a single row per query. See the reference
#'   below for an explanation of the data frame columns.
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
cartociudad_reverse_geocode <- function(latitude, longitude) {

  stopifnot(length(latitude) == length(longitude))

  names_res <- c("type", "tip_via", "address", "portalNumber", "id",
                 "muni", "province", "postalCode", "lat", "lng")
  results   <- as.data.frame(
    matrix(
      ncol = length(names_res),
      nrow = length(latitude)
    )
  )
  colnames(results) <- names_res
  res_list          <- list()

  url <- "http://www.cartociudad.es/services/api/geocoder/reverseGeocode"
  ua <- get_cartociudad_user_agent()

  for (i in seq_along(latitude)) {
    query.parms <- list(lat = latitude[i], lon = longitude[i])
    res         <- httr::GET(url, query = query.parms, ua)

    if (httr::http_error(res)) {
      warning("Error in query ", i, ": ", httr::http_status(res)$message)
      results[i, c("lat", "lng")] <- c(latitude[i], longitude[i])
    } else {
      info          <- httr::content(res)
      res_list[[i]] <- as.data.frame(t(unlist(info)), stringsAsFactors = FALSE)[, names_res]
    }
  }

  if (length(res_list) == 1) {
    results <- res_list[[1]]
  } else {
    results <- do.call(rbind_lists_df, res_list)
  }

  return(results)
}
