% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/collect_activity.R
\name{collect_activity}
\alias{collect_activity}
\title{Collect fitbit activity data}
\usage{
collect_activity(token, start_date = NULL, days_prior_to_start = 30)
}
\arguments{
\item{token}{The token you received from `fitbitr` function \code{\link[fitbitr]{oauth_token}}}

\item{start_date}{The date that you want to start collecting the data in "YYYY-MM-DD" format. If `NULL` (default) then it chooses yesterday.}

\item{days_prior_to_start}{Days before `start_date` that you want to collect data from. Default is 30 days.}
}
\value{
Returns a list of lists for each type of activity.
}
\description{
Collects all of the "activity" data from the FitBit API.
}
