\name{cartociudad_reverse_geocode}
\alias{cartociudad_reverse_geocode}

\title{Reverse geocoding of locations}
\description{
  Returns the address details of a geographical point in Spain}
\usage{cartociudad_reverse_geocode(latitude, longitude)}

\arguments{
  \item{latitude}{Point latitude in geographical coordinates (e.g., 40.473219)}
  \item{longitude}{Point longitude in geographical coordinates (e.g., -3.7227241)}
}

\details{This function performs reverse geocoding of a location. It returns the details of the closest address in Spain.}

\value{
A list with the following items:

\item{tipo}{type of location.}
\item{tipo.via}{road type.}
\item{nombre.via}{road name.}
\item{num.via}{road number.}
\item{num.via.id}{internal id of this address in cartociudad database.}
\item{municipio}{town.}
\item{provincia}{province.}
\item{cod.postal}{zip code.}
}
\references{
\url{http://www.cartociudad.es/recursos/Documentacion_tecnica/CARTOCIUDAD_ServiciosWeb.pdf}
}
\author{Luz Frias}

\examples{
cartociudad_reverse_geocode(40.473219, -3.7227241)
}
