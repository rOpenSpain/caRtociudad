\name{get_cartociudadmap}
\alias{get_cartociudadmap}

\title{Get a Cartociudad Map}
\description{Downloads static maps using Cartociudad API. These maps can be then used by functions such as \code{ggmap}}

\usage{
get_cartociudadmap(center, radius, 
    layers = c("FondoUrbano", "Vial", "Portal", "Toponimo"), 
    add.censal.section = FALSE,
    height = 600, width = 600)
}

\arguments{
  \item{center}{a pair of numbers (latitude and longitude of the center of the map)}
  \item{radius}{approximate map "width" in kilometers}
  \item{layers}{layers the map should include; Cartociudad API documentation lists a number of them, some of which are only available in a limited number of provinces}
  \item{add.censal.section}{whether to add the limit of censal sections and districts to the base map; note that this layer may not be available at low zoom levels}
  \item{height}{map height in pixels}
  \item{width}{map width in pixels}
}

\details{This function, similar to \code{get_googlemap} or \code{get_openstreetmap} downloads a map from Cartociudad API and creates a \code{ggmap} compatible version of it.}

\value{An object of class \code{ggmap} and \code{raster} which can be used within the \code{ggmap}framework.}
\references{
\url{http://www.cartociudad.es/recursos/Documentacion_tecnica/CARTOCIUDAD_ServiciosWeb.pdf}
}
\author{
Carlos J. Gil Bellosta
}

\examples{
\dontrun{
  soria <- cartociudad_geocode("soria")
  mapa_soria <- get_cartociudadmap(c(soria$latitude, soria$longitude), 1)
  ggmap(mapa_soria)
}
}

