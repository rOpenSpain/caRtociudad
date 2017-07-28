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
#' res <- get_cartociudad_route(c(39.48,-0.37),
#'    c(39.484336,-0.358171),
#'    vehicle = "car")
#'
#' @export
#'
get_cartociudad_route <- function(latlon.orig, latlon.dest, vehicle = "car"){

  # query parms:

  query.parms <- list(
    orig             = paste(latlon.orig, collapse = ","),
    dest             = paste(latlon.dest, collapse = ","),
    locale           = "es",
    vehicle          = vehicle
  )

  url <- "http://www.cartociudad.es/services/api/route"
  ua <- get_cartociudad_user_agent()

  res <- httr::GET(url, query = query.parms, ua)
  httr::stop_for_status(res)

  res <- httr::content(res, as = "parsed", type = "application/json")

  if (res$found != "true")
    warning("The route could not be found")

  res$bbox      <- as.numeric(unlist(res$bbox))
  res$distance  <- as.numeric(res$distance)
  res$found     <- res$found == "true"
  res$from      <- as.numeric(strsplit(res$from, ",")[[1]])
  res$to        <- as.numeric(strsplit(res$to  , ",")[[1]])
  res$time      <- as.numeric(res$time)

  res$info$routeFound    <- res$info$routeFound == "true"
  res$info$took          <- as.numeric(res$info$took)
  res$info$tookGeocoding <- as.numeric(res$info$tookGeocoding)

  res$instructionsData   <- plyr::ldply(res$instructionsData$instruction, unlist)
  res$instructionsData$distance <- gsub(" m", "", res$instructionsData$distance)
  res$instructionsData[, colnames(res$instructionsData) != "description"] <-
    lapply(res$instructionsData[, colnames(res$instructionsData) != "description"], as.numeric)

  return(res)
}
