##########################################################################
# Luz frías, 2016-04-08
# Gets location info (mun, prov, censal section, etc.) for a location
##########################################################################

get_cartociudad_census_info <- function(bbox, year) {
  
  # The layers are associated to the year
  layer.secciones <- paste0(year, "_Secciones")
  layer.distritos <- paste0(year, "_Distritos")
  layers <- c(layer.secciones, layer.distritos)
  
  query.parms <- list(
    bbox             = paste(bbox,   collapse = ","),
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
  ua <- get_cartociudad_user_agent()
  
  res <- GET(url, query = query.parms, ua)
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

get_cartociudad_cadastral_info <- function(bbox) {
  
  layer <- "Catastro"
  # BBOX structure for cadastre API is (lon, lat, lon, lat)
  bbox <- c(bbox[2], bbox[1], bbox[4], bbox[3])
  
  query.parms <- list(
    bbox             = paste(bbox, collapse = ","),
    layers           = layer,
    query_layers     = layer,
    width            = 101,
    height           = 101,
    X                = 50,
    Y                = 50,
    version          = "1.1.1",
    format           = "image/png",
    info_format      = "text/html",
    service          = "WMS",
    request          = "GetFeatureInfo",
    styles           = "",
    srs              = "EPSG:4258"  
  )
  
  url <- "http://ovc.catastro.meh.es/Cartografia/WMS/ServidorWMS.aspx"
  ua <- get_cartociudad_user_agent()
  
  res <- GET(url, query = query.parms, ua)
  stop_for_status(res)
  info <- content(res, "parsed")
  
  # Parse the response
  if (is.null(info) || xml_length(info) == 0) {
    return(list())
  }
  node <- xml_find_one(info, "//a[@href]")
  
  list(ref.catastral     = xml_text(node),
       url.ref.catastral = xml_attr(node, "href"))
}

get_cartociudad_location_info <- function(latitude, longitude, year = 2011,
                                          info.source = c("census", "cadastre", "reverse")){
  
  bbox1 <- latitude
  bbox2 <- longitude
  # if the bbox has no area, the request fails
  bbox3 <- latitude  + 1e-5
  bbox4 <- longitude + 1e-5
  bbox <- c(bbox1, bbox2, bbox3, bbox4)
  
  result <- list()
  
  if ("census" %in% info.source) {
    result <- get_cartociudad_census_info(bbox, year)
  }
  if ("cadastre" %in% info.source) {
    result <- append(result, get_cartociudad_cadastral_info(bbox))
  }
  if ("reverse" %in% info.source) {
    result <- append(result, cartociudad_reverse_geocode(latitude, longitude))
  }
  
  # Avoid duplicated information. Different sources may both return results for
  #  the same field (e.g. province)
  result[unique(names(result))]
}
