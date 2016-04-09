##########################################################################
# Luz frías, 2016-04-08
# Gets location info (mun, prov, censal section, etc.) for a location
##########################################################################

get_cartociudad_location_info <- function(latitude, longitude, year = 2011){
  
  bbox1 <- latitude
  bbox2 <- longitude
  # if the bbox has no area, the request fails
  bbox3 <- latitude  + 1e-5
  bbox4 <- longitude + 1e-5
  
  # The layers are associated to the year
  layer.secciones <- paste0(year, "_Secciones")
  layer.distritos <- paste0(year, "_Distritos")
  layers <- c(layer.secciones, layer.distritos)
  
  query.parms <- list(
    bbox             = paste(bbox1, bbox2, bbox3, bbox4, sep = ","),
    layers           = paste(layers, collapse = ","),
    query_layers     = paste(layers, collapse = ","),
    width            = 1,
    height           = 1,
    version          = "1.3.0",
    format           = "text/xml",
    info_format      = "text/xml",
    service          = "WMS",
    request          = "GetFeatureInfo",
    styles           = "",
    crs              = "EPSG:4258"  
  )
  
  url <- "http://servicios.internet.ine.es/WMS/WMS_INE_SECCIONES_G01/MapServer/WMSServer"
  
  res <- GET(url, query = query.parms)
  stop_for_status(res)
  info <- content(res, "parsed", encoding = "UTF-8")
  
  # Parse the response
  if (xml_length(info) == 0) {
    return(list())
  }
  node.sec <- xml_find_one(info, '//*[@CUSEC]')
  node.dis <- xml_find_one(info, '//*[@CUDIS]')
  
  list(seccion   = xml_attr(node.sec, "CUSEC"),
       distrito  = xml_attr(node.dis, "CUDIS"),
       provincia = xml_attr(node.sec, "NPRO"),
       municipio = xml_attr(node.sec, "NMUN"))
}