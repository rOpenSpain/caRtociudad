\name{get_cartociudad_area}
\alias{get_cartociudad_area}

\title{Area calculation}
\description{
  Returns the polygon that describes the area}
\usage{get_cartociudad_area(latitude, longitude, radius)}

\arguments{
  \item{latitude}{Point latitude in geographical coordinates (e.g., 40.3930144)}
  \item{longitude}{Point longitude in geographical coordinates (e.g., -3.6596683)}
  \item{radius}{Distance in meters (e.g., 500)}
}

\details{This function calculates the area given a point and a radius in meters}

\value{
A dataframe with the polygon that describes the area.
}
\references{
\url{http://www.cartociudad.es/recursos/Documentacion_tecnica/CARTOCIUDAD_ServiciosWeb.pdf}
}
\author{Luz Frias}

\examples{
get_cartociudad_area(40.3930144, -3.6596683, 500)
}
