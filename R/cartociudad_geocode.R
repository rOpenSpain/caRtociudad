##########################################################################
# @gilbellosta, 2016-03-30
# Calls to Cartociudad geocoding API
##########################################################################

#' @title Interface to Cartociudad geolocation API
#'
#' @description Geolocation of Spanish addresses via Cartociudad API calls,
#'   providing the full address in a single text string via \code{full_address}.
#'   It is advisable to add the street type (calle, etc.) and to omit the
#'   country name.
#'
#' @usage cartociudad_geocode(full_address, version = c("current", "prev"),
#'   output_format = "JSON", on_error = c("warn", "fail"), ntries = 10)
#'
#' @param full_address Character string providing the full address to be
#'   geolocated; e.g., "calle miguel servet 5, zaragoza". Adding the country may
#'   cause problems.
#' @param version Character string. Geocoder version to use: \code{current} or
#'   \code{prev}.
#' @param output_format Character string. Output format of the query:
#'   \code{JSON} or \code{GeoJSON}. Only applicable if you choose version =
#'   "current".
#' @param on_error Character string. Defaults to \code{warn}: in case of errors,
#'   the function will return an empty \code{data.frame} and a warning. Set it
#'   to \code{fail} to stop the function call in case of errors in the API call.
#' @param ntries Numeric. In case of connection failure, number of \code{GET}
#'   requests to be made before stopping the function call.
#'
#' @return A data frame consisting of a single row per query. See the reference
#'   below for an explanation of the data frame columns.
#'
#' @author Carlos J. Gil Bellosta
#'
#' @references
#' \url{http://www.cartociudad.es/recursos/Documentacion_tecnica/CARTOCIUDAD_ServiciosWeb.pdf}
#'
#' @examples
#' # Query a single address
#' address <- "plaza de cascorro 11, 28005 madrid"
#' my.address <- cartociudad_geocode(full_address = address)
#' print(my.address)
#'
#' # Query multiple addresses
#' address <- c(address, "plaza del ayunamiento 1, valencia")
#' my.address <- cartociudad_geocode(full_address = address)
#' print(my.address)
#'
#' @export
#'
cartociudad_geocode <- function(full_address, version = c("current", "prev"),
                                output_format = "JSON", on_error = c("warn", "fail"),
                                ntries = 1) {

  stopifnot(class(full_address) == "character")
  stopifnot(length(full_address) >= 1)
  version    <- match.arg(version)
  on_error   <- match.arg(on_error)
  no_geocode <- which(nchar(full_address) == 0)
  total      <- length(full_address)
  res_list   <- vector("list", total)
  curr_names <- c("id", "province", "muni", "tip_via", "address", "portalNumber",
                  "refCatastral", "postalCode", "lat", "lng", "stateMsg",
                  "state", "type")
  prev_names <- c("road_fid", "province", "municipality", "road_type", "road_name",
                  "numpk_name", "numpk_fid", "zip", "latitude", "longitude",
                  "comments", "status")
  pb         <- utils::txtProgressBar(min = 0, max = total, style = 3)
  empty_df   <- as.data.frame(
    matrix(NA_character_, nrow = 0, ncol = length(curr_names), dimnames = list(c(), curr_names)),
    stringsAsFactors = FALSE
  )

  for (i in seq_len(total)) {
    res_list[[i]] <- empty_df
    if (!i %in% no_geocode) {
      ua  <- get_cartociudad_user_agent()
      if (version == "current") {
        api.args <- list(q = full_address[i], outputformat = output_format)
        get_url  <- "http://www.cartociudad.es/geocoder/api/geocoder/findJsonp"
      } else {
        api.args <- list(max_results = 1, address = full_address[i])
        get_url  <- "http://www.cartociudad.es/CartoGeocoder/Geocode"
      }
      res        <- get_ntries(get_url, api.args, ua, ntries)

      if (httr::http_error(res)) {
        if (on_error == "fail")
          stop("Call to cartociudad API failed with error code ", res$status_code)
        warning("Error in query ", i, ": ", httr::http_status(res)$message)
        res_list[[i]] <- plyr::rbind.fill(
          res_list[[i]],
          data.frame(address = full_address[i], version = version, stringsAsFactors = FALSE)
        )
      } else {
        res <- jsonp_to_json(suppressMessages(httr::content(res, as = "text")))
        res <- jsonlite::fromJSON(res)
        res <- res[-which(names(res) %in% c("geom", "countryCode", "error", "success"))]
        if (version == "current") {
          res <- lapply(res, function(x) ifelse(is.null(x), NA_character_, x))
        } else {
          res <- res[[1]]
        }
        if (length(res) == 0) {
          warning("The query has 0 results.")
          res_list[[i]] <- plyr::rbind.fill(
            res_list[[i]],
            data.frame(address = full_address[i], version = version, stringsAsFactors = FALSE)
          )
        } else {
          if (version == "current") {
            res_list[[i]] <- as.data.frame(t(unlist(res)), stringsAsFactors = FALSE)[, curr_names]
            res_list[[i]] <- cbind(res_list[[i]], version = "current")
          } else {
            res_list[[i]] <- cbind(res[, prev_names], type = NA_character_, version = "prev")
            names(res_list[[i]])     <- c(curr_names, "version")
            row.names(res_list[[i]]) <- NULL
          }
        }
      }
    } else {
      warning("Empty string as query: NA returned.")
      res_list[[i]] <- empty_df[1, ]
    }
    utils::setTxtProgressBar(pb, i)
  }

  cat("\n")
  results <- plyr::rbind.fill(res_list)
  results[, c("lat", "lng")] <- apply(results[, c("lat", "lng")], 2, as.numeric)
  return(results)
}
