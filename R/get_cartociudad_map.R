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
#' @usage get_cartociudad_map(center, radius, add.censal.section = FALSE,
#'    add.postcode.area = FALSE, add.cadastral.layer = FALSE,
#'    height = 800, width = 1200)
#'
#' @param center a pair of numbers (latitude and longitude of the center of the
#'   map)
#' @param radius approximate map "width" in kilometers
#' @param add.censal.section whether to add the limit of censal sections and
#'   districts to the base map; note that this layer may not be available at low
#'   zoom levels
#' @param add.postcode.area whether to add the limit of postal code areas to
#'   the base map; note that this layer may not be available at low
#'   zoom levels
#' @param add.cadastral.layer whether to add cadastral information
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
#'   soria <- cartociudad_geocode("plaza de san esteban, soria")
#'   soria_map <- get_cartociudad_map(c(soria$lat, soria$lng), 1)
#'   ggmap::ggmap(soria_map)
#' }
#'
#' @export
#'
get_cartociudad_map <- function(center, radius, add.censal.section = FALSE,
                               add.postcode.area = FALSE,
                               add.cadastral.layer = FALSE,
                               height = 800, width = 1200) {

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
    layers           = "IGNBaseTodo",
    width            = width,
    height           = height,
    version          = "1.3.0",
    format           = "image/png",
    transparent      = "true",
    queryable        = "true",
    service          = "WMS",
    request          = "GetMap",
    styles           = "default",
    exceptions       = "application/vnd.ogc.se_inimage",
    crs              = "EPSG:4326"
  )

  url <- "http://www.ign.es/wms-inspire/ign-base"
  ua <- get_cartociudad_user_agent()
  res <- httr::GET(url, query = query.parms, ua)
  httr::stop_for_status(res)
  my.map <- httr::content(res, as = "parsed", type = "image/png")

  # if another layer is required
  if (add.postcode.area) {
    url <- "http://www.ign.es/wms-inspire/ign-base"
    query <- list(
      service     = "WMS",
      version     = "1.3.0",
      request     = "GetMap",
      format      = "image/png",
      transparent = "true",
      layers      = "codigo-postal",
      crs         = "EPSG:4326",
      styles      = "",
      width       = width,
      height      = height,
      bbox        = paste(bbox1, bbox2, bbox3, bbox4, sep = ","))
    my.map <- overlay_wms_map(my.map, url, query)
  }
  
  if (add.censal.section) {
    url <- "http://servicios.internet.ine.es/WMS/WMS_INE_SECCIONES_G01/MapServer/WMSServer"
    query <- list(
      service     = "WMS",
      version     = "1.3.0",
      request     = "GetMap",
      format      = "image/png",
      transparent = "true",
      layers      = "2018_Secciones,2018_Distritos",
      crs         = "EPSG:4326",
      styles      = "",
      width       = width,
      height      = height,
      bbox        = paste(bbox1, bbox2, bbox3, bbox4, sep = ","))
    my.map <- overlay_wms_map(my.map, url, query)
  }
  
  if (add.cadastral.layer) {
    url <- "http://ovc.catastro.meh.es/Cartografia/WMS/ServidorWMS.aspx"
    
    # transform coordinates to new SRS
    d <- data.frame(Y = c(bbox1, bbox3), X = c(bbox2, bbox4))
    sp::coordinates(d) <- c("X", "Y")
    sp::proj4string(d) <- sp::CRS("+init=epsg:4326") 
    
    CRS.new <- sp::CRS("+init=epsg:3857") # WGS 84
    tmp <- sp::spTransform(d, CRS.new)
    tmp <- tmp@coords
    
    new_bbox <- c(tmp[1,1], tmp[1,2], tmp[2,1], tmp[2,2])
    
    query <- list(
      service     = "WMS",
      version     = "1.1.1",
      request     = "GetMap",
      format      = "image/png",
      transparent = "true",
      layers      = "CONSTRU,TXTCONSTRU,SUBPARCE,TXTSUBPARCE,PARCELA,TXTPARCELA,MASA,TXTMASA",
      srs         = "EPSG:3857",
      styles      = "",
      width       = width,
      height      = height,
      bbox        = paste(new_bbox, collapse = ","))
    my.map <- overlay_wms_map(my.map, url, query)
  }
  
  
  # my.map <- t(apply(my.map, 2, rgb))
  my.map <- grDevices::rgb(my.map[, , 1], my.map[, , 2],
                           my.map[, , 3], my.map[, , 4])
  my.map <- t(matrix(my.map, width, height, byrow = TRUE))
  my.map <- grDevices::as.raster(my.map)

  class(my.map) <- c("ggmap", "raster")
  attr(my.map, "bb") <- data.frame(ll.lat = bbox1, ll.lon = bbox2,
                                   ur.lat = bbox3, ur.lon = bbox4)
  my.map
}
