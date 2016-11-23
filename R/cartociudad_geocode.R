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
    api.args <- lapply(as.list(match.call())[-1], eval)
    
    if(!is.null(max_results))
      api.args$max_results <- max_results
    
    ua <- get_cartociudad_user_agent()
    
    res <- if (!missing(full_address)){
                api.args$address <- full_address
                GET("http://www.cartociudad.es/CartoGeocoder/Geocode", query = api.args, ua)
           }
           else
                GET("http://www.cartociudad.es/CartoGeocoder/GeocodeAddress", query = api.args, ua)
    
    stop_for_status(res)
    
    res <- content(res, as = "text")
    res <- jsonlite::fromJSON(res, simplifyDataFrame = TRUE)
    res$result
}
