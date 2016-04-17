\name{get_cartociudad_location_info}
\alias{get_cartociudad_location_info}

\title{Administrative information for a location}
\description{
Returns the administrative information related to a geographical point in Spain: province, municipality, censal district, censal section and cadastral reference}
\usage{get_cartociudad_location_info(latitude, longitude, year = 2011,
  info.source = c("census", "cadastre"))}

\arguments{
  \item{latitude}{Point latitude in geographical coordinates (e.g., 40.473219)}
  \item{longitude}{Point longitude in geographical coordinates (e.g., -3.7227241)}
  \item{year}{Reference year; see Details section}
  \item{info.source}{A character vector specifying the APIs to consult. Possible values are "census" and "cadastre"}
}

\details{This function consults administrative information for a point within Spain. Censal information is consulted from a different set of layers, each one corresponding to a different year. Whereas provincial and municipal information is mostly stable, censal districts and sections may be subject to greater changes over the years.

The default value for \code{year}, 2011, corresponds to the last census.}

\value{A list contaning the administrative information for the given point. For \code{info.source = "census"} it contains the province, municipality, censal discrict and censal section codes. For \code{info.source = "cadastre"} it contains the cadastral reference and the url to the spanish cadastre website. }

\references{INE's web service is mostly undocumented and the function has been built by reverse engineering API calls. However, users may want to check the \emph{capabilities} of INEs WMS service at \url{http://goo.gl/aKn3vj}.
Cadastre web service documentation can be consulted at \url{http://goo.gl/lKkwK} and WMS service \emph{capabilities} at \url{http://goo.gl/5JAd9N}.
}
\author{Luz Frías with small edits by Carlos J. Gil Bellosta}

\examples{
get_cartociudad_location_info(40.473219, -3.7227241, year = 2015)
}
