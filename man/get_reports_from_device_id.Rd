% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/get_reports_from_unique_id.R
\name{get_reports_from_device_id}
\alias{get_reports_from_device_id}
\title{Get reports from device id}
\usage{
get_reports_from_device_id(
  url,
  user,
  pass,
  device_id,
  report_type,
  path = "api/reports/"
)
}
\arguments{
\item{url}{The url of your traccar api}

\item{user}{The username for your traccar api}

\item{pass}{The password for your traccar api}

\item{device_id}{The id for a registered HCW on the traccar api}

\item{report_type}{The type of report: trips, summary, stops, route, events}

\item{path}{API path}
}
\value{
A dataframe
}
\description{
Retrieve reports from api/positions using device_id
}
