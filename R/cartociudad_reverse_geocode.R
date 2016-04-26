##########################################################################
# Luz Frias, 2016-04-26
# Reverse geocoding of a location using cartociudad API
##########################################################################

cartociudad_reverse_geocode <- function(latitude, longitude) {
  
  query.parms <- list(
    lat = latitude,
    lon = longitude
  )
  
  url <- "http://www.cartociudad.es/services/api/geocoder/reverseGeocode"
  
  res <- GET(url, query = query.parms)
  stop_for_status(res)
  info <- content(res)
  
  # Parse the response
  list(
    tipo       = info$type,
    tipo.via   = info$tip_via,
    nombre.via = info$address,
    num.via    = info$portalNumber,
    num.via.id = info$id,
    municipio  = info$muni,
    provincia  = info$province,
    cod.postal = info$postalCode
  )
}
