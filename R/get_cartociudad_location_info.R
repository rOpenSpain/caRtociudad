##########################################################################
# Luz frías, 2016-04-08
# Gets location info (mun, prov, censal section, etc.) for a location
##########################################################################

# get_cartociudad_census_info <- function(bbox, year) {
#   if (!year %in% c(2001, 2007:2016))
#     warning("We have no census data for this year (available years: 2001, 2007-2016).")
# 
#   # The layers are associated to the year
#   if (year == 2001) {
#     layer.secciones <- paste0(year, "_CPV_Secciones")
#     layer.distritos <- paste0(year, "_CPV_Distritos")
#   } else if (year %in% c(2007, 2010:2011)) {
#     layer.secciones <- paste0(year, "_PA_Secciones")
#     layer.distritos <- paste0(year, "_PA_Distritos")
#   } else {
#     layer.secciones <- paste0(year, "_Secciones")
#     layer.distritos <- paste0(year, "_Distritos")
#   }
#   layers <- c(layer.secciones, layer.distritos)
# 
#   query.parms <- list(
#     bbox             = paste(bbox,   collapse = ","),
#     layers           = paste(layers, collapse = ","),
#     query_layers     = paste(layers, collapse = ","),
#     width            = 1,
#     height           = 1,
#     version          = "1.3.0",
#     format           = "text/xml",
#     info_format      = "text/xml",
#     service          = "WMS",
#     request          = "GetFeatureInfo",
#     styles           = "",
#     crs              = "EPSG:4258"
#   )
# 
#   url <- "http://servicios.internet.ine.es/WMS/WMS_INE_SECCIONES_G01/MapServer/WMSServer"
#   ua <- get_cartociudad_user_agent()
# 
#   res <- httr::GET(url, query = query.parms, ua)
#   httr::stop_for_status(res)
#   info <- httr::content(res, "parsed", encoding = "UTF-8")
# 
#   # Parse the response
#   if (xml2::xml_length(info) == 0) {
#     return(list())
#   }
#   node.sec <- xml2::xml_find_first(info, '//*[@CUSEC]')
#   node.dis <- xml2::xml_find_first(info, '//*[@CUDIS]')
# 
#   res <- list(seccion   = xml2::xml_attr(node.sec, "CUSEC"),
#               distrito  = xml2::xml_attr(node.dis, "CUDIS"),
#               provincia = xml2::xml_attr(node.sec, "NPRO"),
#               municipio = xml2::xml_attr(node.sec, "NMUN"))
#   return(res)
# }
# 
# get_cartociudad_cadastral_info <- function(bbox) {
# 
#   layer <- "Catastro"
#   # BBOX structure for cadastre API is (lon, lat, lon, lat)
#   bbox <- c(bbox[2], bbox[1], bbox[4], bbox[3])
# 
#   query.parms <- list(
#     bbox             = paste(bbox, collapse = ","),
#     layers           = layer,
#     query_layers     = layer,
#     width            = 101,
#     height           = 101,
#     X                = 50,
#     Y                = 50,
#     version          = "1.1.1",
#     format           = "image/png",
#     info_format      = "text/html",
#     service          = "WMS",
#     request          = "GetFeatureInfo",
#     styles           = "",
#     srs              = "EPSG:4258"
#   )
# 
#   url <- "http://ovc.catastro.meh.es/Cartografia/WMS/ServidorWMS.aspx"
#   ua <- get_cartociudad_user_agent()
# 
#   res <- httr::GET(url, query = query.parms, ua)
#   httr::stop_for_status(res)
#   info <- httr::content(res, "parsed")
# 
#   # Parse the response
#   if (is.null(info) || xml2::xml_length(info) == 0) {
#     return(list())
#   }
#   node <- xml2::xml_find_first(info, "//a[@href]")
#   res <- list(ref.catastral     = xml2::xml_text(node),
#               url.ref.catastral = xml2::xml_attr(node, "href"))
#   return(res)
# }





#' @title Administrative information for a location
#'
#' @description Returns the administrative information related to a geographical
#'   point in Spain: province, municipality, censal district, censal section,
#'   cadastral reference and reverse geocoding data.
#'
#' @details This function consults administrative information for a point within
#'   Spain. Censal information is consulted from a different set of layers, each
#'   one corresponding to a different year. Whereas provincial and municipal
#'   information is mostly stable, censal districts and sections may be subject
#'   to greater changes over the years.
#'
#' @usage get_cartociudad_location_info(latitude, longitude, year = 2016,
#'   info.source = c("census", "cadastre", "reverse"))
#'
#' @param latitude Point latitude in geographical coordinates (e.g., 40.473219)
#' @param longitude Point longitude in geographical coordinates (e.g.,
#'   -3.7227241)
#' @param year Reference year; see Details section
#' @param info.source A character vector specifying the APIs to consult.
#'   Possible values are "census", "cadastre" and "reverse"
#'
#' @return A list contaning the administrative information for the given point.
#'   For \code{info.source = "census"} it contains the province, municipality,
#'   censal discrict and censal section codes. For \code{info.source =
#'   "cadastre"} it contains the cadastral reference and the url to the spanish
#'   cadastre website. For \code{info.source = "reverse"} it contains the
#'   details of the address closest to the specified location, such us road
#'   type, number, zip code, street name, ... More information about reverse
#'   geocoding in \code{\link{cartociudad_reverse_geocode}}.
#'
#' @author Luz Frías with small edits by Carlos J. Gil Bellosta
#'
#' @references INE's web service is mostly undocumented and the function has
#'   been built by reverse engineering API calls. However, users may want to
#'   check the \emph{capabilities} of INEs WMS service at
#'   \url{http://goo.gl/aKn3vj}. Cadastre web service documentation can be
#'   consulted at \url{http://goo.gl/lKkwK} and WMS service \emph{capabilities}
#'   at \url{http://goo.gl/5JAd9N}.
#'
#' @examples
#' get_cartociudad_location_info(40.473219, -3.7227241)
#'
#' @export
#'
get_cartociudad_location_info <- function(latitude, longitude, year = 2016,
                                          info.source = c("census", "cadastre", "reverse")) {
  
  .Deprecated("cartociudad_get_location_info")
  
  cartociudad_get_location_info(latitude, longitude, year, info.source)
}
