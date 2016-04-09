\name{get_cartociudad_location_info}
\alias{get_cartociudad_location_info}

\title{Administrative information for a location}
\description{
Returns the administrative information related to a geographical point in Spain: province, municipality, censal district and censal section}
\usage{get_cartociudad_location_info(latitude, longitude, year = 2011)}

\arguments{
  \item{latitude}{Point latitude in geographical coordinates (e.g., 40.473219)}
  \item{longitude}{Point longitude in geographical coordinates (e.g., -3.7227241)}
  \item{year}{Reference year; see Details section}
}

\details{The API this function consults provides administrative information for a point within Spain from a different set of layers, each one corresponding to a different year. Whereas provincial and municipal information is mostly stable, censal districts and sections may be subject to greater changes over the years. 

The default value for \code{year}, 2011, corresponds to the last census.}

\value{A data frame containing the province, municipality, censal discrict and censal section codes for the given point.}

\references{INE's web service is mostly undocumented and the function has been built by reverse engineering API calls. However, users may want to check the \emph{capabilities} of INEs WMS service at \url{http://goo.gl/aKn3vj}.
}
\author{Luz Frías with small edits by Carlos J. Gil Bellosta}

\examples{
get_cartociudad_location_info(40.473219, -3.7227241, year = 2015)
}
