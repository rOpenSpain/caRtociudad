##########################################################################
# @gilbellosta, 2016-03-30
# Calls to Cartociudad geocoding API
##########################################################################

cartociudad_geocode <- function(full_address, 
                                province,
                                municipality,
                                road_type,
                                road_name,
                                road_number,
                                zip,
                                max_results = 3)
{
    api.args <- as.list(match.call())[-1]
    
    if(!is.null(max_results))
      api.args$max_results <- max_results
  
    res <- if (!missing(full_address)){
                api.args$address <- full_address
                GET("http://www.cartociudad.es/CartoGeocoder/Geocode", query = api.args)
           }
           else
                GET("http://www.cartociudad.es/CartoGeocoder/GeocodeAddress", query = api.args)
    
    res <- content(res, as = "text")
    res <- jsonlite::fromJSON(res, simplifyDataFrame = TRUE)
    
    if (!res$success){
      stop("Cartociudad found an error in your request: ", res$error$description)
    }     
    
    res$result
}
