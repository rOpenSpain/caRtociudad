##########################################################################
# @gilbellosta, 2016-03-30
# Gets routes between two points 
##########################################################################

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
  
  res <- GET(url, query = query.parms, ua)
  stop_for_status(res)
  
  res <- content(res, as = "parsed", type = "application/json")
  
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
  
  res$instructionsData   <- ldply(res$instructionsData$instruction, unlist)
  res$instructionsData$distance <- gsub(" m", "", res$instructionsData$distance)
  res$instructionsData[, colnames(res$instructionsData) != "description"] <- 
    lapply(res$instructionsData[, colnames(res$instructionsData) != "description"], as.numeric)
  
  return(res)
}