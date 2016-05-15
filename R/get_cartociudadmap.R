##########################################################################
# @gilbellosta, 2016-03-30
# Gets ggmap compatible maps from Cartociudad
##########################################################################

get_cartociudadmap <- function(center, radius, 
                        layers = c("FondoUrbano", "Vial", "Portal", "Toponimo"), 
                        add.censal.section = FALSE,
                        height = 600, width = 600){
  
  # calculate bobx via an approximation
  delta <- 0.01
  deg.east  <- radius * delta * distHaversine(center, c(center[1], center[2] + delta)) / 2000  # half & meters
  deg.north <- radius * delta * distHaversine(center, c(center[1] + delta, center[2])) / 2000 
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
  
  res <- GET(url, query = query.parms)
  stop_for_status(res)
  
  my.map <- content(res, as = "parsed", type = "image/png")
  
  # if another layer is required
  if(add.censal.section){
    
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
    
    res <- GET(url, query = query.parms)
    warn_for_status(res)   # data may not be available at a given map resolution
    
    my.map <- tryCatch(
      {
        cs.layer <- content(res, as = "parsed", type = "image/png")

        # png overlay taking transparency into account
        # note that cs layer has transparency 0/1
        mask <- array(cs.layer[,,4], dim(cs.layer))
        (1-mask) * my.map + mask * cs.layer    
        
      }, 
      error = function(x) return(my.map),     # we have already warned
      warning = function(x) return(my.map)    # ditto
    )
    
  }
  
  #my.map <- t(apply(my.map, 2, rgb))
  my.map <- rgb(my.map[,,1], my.map[,,2], my.map[,,3], my.map[,,4])
  my.map <- t(matrix(my.map, height, width))
  
  class(my.map) <- c("ggmap", "raster")
  attr(my.map, "bb") <- data.frame(ll.lat = bbox1, ll.lon = bbox2, 
                                   ur.lat = bbox3, ur.lon = bbox4)
  
  my.map
}