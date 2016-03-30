\name{cartociudad_geocode}
\alias{cartociudad_geocode}

\title{Interface to Cartociudad geolocation API}

\description{Geolocation of Spanish addresses via Cartociudad API calls}
\usage{
cartociudad_geocode(full_address, province, municipality, 
  road_type, road_name, road_number, 
  zip, max_results = 3)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{full_address}{character string providing the full address to be geolocated; e.g., "calle miguel servet 5, zaragoza". Adding the country may cause problems.}
  \item{province}{province name}
  \item{municipality}{town/city name}
  \item{road_type}{road type, i.e., "calle", "avenida", etc.}
  \item{road_name}{street name}
  \item{road_number}{street number}
  \item{zip}{postal code}
  \item{max_results}{maximum number of lines to return}
}

\details{There are two ways to query the API. The first one is providing the full address in a single text string via \code{full_address}. It is advisable to add the street type (calle, etc.) and to omit the country name.

Alternatively, you can provide all (or some) the address chunks using the remaining arguments. Note that if \code{full_address} is provided, the remaining address arguments will be ignored. Note that the API call will result in an error if some "key" parameters are missing (e.g., "province").
}

\value{
A data frame consisting of a single row per guess. See the reference below for an explanation of the data frame columns.
}
\references{
\url{http://www.cartociudad.es/recursos/Documentacion_tecnica/CARTOCIUDAD_ServiciosWeb.pdf}
}
\author{
Carlos J. Gil Bellosta
}

\examples{
# using full address
my.address <- cartociudad_geocode("plaza de cascorro 11, 28005 madrid")
print(my.address)

# using address chunks
my.address <- cartociudad_geocode(road_type = "plaza", road_name = "cascorro",
    zip = "28012", municipality = "madrid", province = "madrid")
print(my.address)    
}

