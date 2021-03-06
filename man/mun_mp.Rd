% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/mun_mp.R
\name{mun_mp}
\alias{mun_mp}
\title{mun_mp}
\usage{
mun_mp(data, grid = FALSE, density = FALSE, line = FALSE,
  text = FALSE)
}
\description{
A function for the milk mun-protein analysis
}
\examples{
mun_mp(data = dairyCattle::read_cattle("cattle_data.xls", drop.zero = TRUE, add = TRUE), grid=TRUE)
}
\keyword{MUN}
\keyword{cattle}
\keyword{dairy}
