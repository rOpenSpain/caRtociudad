##########################################################################
# @gilbellosta, 2016-03-30
# Gets ggmap compatible maps from Cartociudad
##########################################################################

#' @title Get a Cartociudad Map
#'
#' @description Downloads static maps using Cartociudad API. These maps can be
#'   then plotted by functions such as \code{ggmap}.
#'
#' @details This function, similar to \code{get_googlemap} or
#'   \code{get_openstreetmap} downloads a map from Cartociudad API and creates a
#'   \code{ggmap} compatible version of it.
#'
#' @usage get_cartociudadmap(center, radius, add.censal.section = FALSE,
#'    layers = c("FondoUrbano", "Vial", "Portal", "Toponimo"),
#'    height = 600, width = 600)
#'
#' @param center a pair of numbers (latitude and longitude of the center of the
#'   map)
#' @param radius approximate map "width" in kilometers
#' @param layers layers the map should include; Cartociudad API documentation
#'   lists a number of them, some of which are only available in a limited
#'   number of provinces
#' @param add.censal.section whether to add the limit of censal sections and
#'   districts to the base map; note that this layer may not be available at low
#'   zoom levels
#' @param height map height in pixels
#' @param width map width in pixels
#'
#' @return An object of class \code{ggmap} and \code{raster} which can be used
#'   within the \code{ggmap}framework.
#'
#' @author Carlos J. Gil Bellosta
#'
#' @references
#' \url{http://www.cartociudad.es/recursos/Documentacion_tecnica/CARTOCIUDAD_ServiciosWeb.pdf}
#'
#' @examples
#' \dontrun{
#'   soria <- cartociudad_geocode("ayuntamiento soria")
#'   soria_map <- get_cartociudadmap(c(soria$lat, soria$lng), 1)
#'   ggmap(soria_map)
#' }
#'
#' @export
#'
get_cartociudadmap <- function(center, radius, add.censal.section = FALSE,
                        layers = c("FondoUrbano", "Vial", "Portal", "Toponimo"),
                        height = 600, width = 600) {

  # calculate bobx via an approximation
  delta <- 0.01
  deg.east  <- radius * delta *
    geosphere::distHaversine(center, c(center[1], center[2] + delta)) / 2000  # half & meters
  deg.north <- radius * delta *
    geosphere::distHaversine(center, c(center[1] + delta, center[2])) / 2000
  deg.north <- deg.north * height / width

  bbox1 <- center[1] - deg.north
  bbox2 <- center[2] - deg.east
  bbox3 <- center[1] + deg.north
  bbox4 <- center[2] + deg.east

  # query parms:
  query.parms <- list(
    bbox             = paste(bbox1, bbox2, bbox3, bbox4, sep = ","),
    layers           = paste(layers, collapse = ","),
    width            = width,
    height           = height,
    version          = "1.3.0",
    format           = "image/png",
    transparent      = "true",
    queryable        = "true",
    service          = "WMS",
    request          = "GetMap",
    styles           = "",
    exceptions       = "application/vnd.ogc.se_inimage",
    crs              = "EPSG:4258"
  )

  url <- "http://www.cartociudad.es/wms/CARTOCIUDAD/CARTOCIUDAD"
  ua <- get_cartociudad_user_agent()
  res <- httr::GET(url, query = query.parms, ua)
  httr::stop_for_status(res)
  my.map <- httr::content(res, as = "parsed", type = "image/png")

  # if another layer is required
  if (add.censal.section) {
    url <- "http://servicios.internet.ine.es/WMS/WMS_INE_SECCIONES_G01/MapServer/WMSServer"
    query.parms <- list(
      service          = "WMS",
      version          = "1.3.0",
      request          = "GetMap",
      format           = "image/png",
      transparent      = "true",
      layers           = "2015_Secciones,2015_Distritos",
      crs              = "EPSG:4258",
      styles           = "",
      width            = width,
      height           = height,
      bbox             = paste(bbox1, bbox2, bbox3, bbox4, sep = ",")
    )

    res <- httr::GET(url, query = query.parms, ua)
    httr::warn_for_status(res) # data may not be available at a given map resolution
    my.map <- tryCatch({
      cs.layer <- httr::content(res, as = "parsed", type = "image/png")
      # png overlay taking transparency into account
      # note that cs layer has transparency 0/1

      mask <- array(cs.layer[, , 4], dim(cs.layer))
      (1 - mask) * my.map + mask * cs.layer
    },
    error = function(x) return(my.map),  # we have already warned
    warning = function(x) return(my.map) # ditto
    )
  }

  # my.map <- t(apply(my.map, 2, rgb))
  my.map <- grDevices::rgb(my.map[, , 1], my.map[, , 2],
                           my.map[, , 3], my.map[, , 4])
  my.map <- t(matrix(my.map, height, width))

  class(my.map) <- c("ggmap", "raster")
  attr(my.map, "bb") <- data.frame(ll.lat = bbox1, ll.lon = bbox2,
                                   ur.lat = bbox3, ur.lon = bbox4)
  my.map
}
