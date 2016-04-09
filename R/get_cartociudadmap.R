##########################################################################
# @gilbellosta, 2016-03-30
# Gets ggmap compatible maps from Cartociudad
##########################################################################

get_cartociudadmap <- function(center, radius, 
                        layers = c("FondoUrbano", "Vial", "Portal", "Toponimo"), 
                        height = 600, width = 600){
  
  # calculate bobx via an approximation
  deg.norte <- 90 * radius / 1e4
  deg.este  <- radius * width / height / 85 
  #deg.este  <- radio * altura.px / anchura.px / 85
  
  bbox1 <- center[1] - deg.norte
  bbox2 <- center[2] - deg.este
  bbox3 <- center[1] + deg.norte
  bbox4 <- center[2] + deg.este
  
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
  
  res <- GET(url, query = query.parms)
  stop_for_status(res)
  
  my.map <- content(res, as = "parsed", type = "image/png")
  my.map <- t(apply(my.map, 2, rgb))
  
  class(my.map) <- c("ggmap", "raster")
  attr(my.map, "bb") <- data.frame(ll.lat = bbox1, ll.lon = bbox2, 
                                 ur.lat = bbox3, ur.lon = bbox4)
  my.map
}