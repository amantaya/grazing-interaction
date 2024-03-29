% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/cameratraps_path_constructor.R
\name{extract_site_code_from_collection_folder}
\alias{extract_site_code_from_collection_folder}
\title{Extract Site Code from Collection Folder}
\usage{
extract_site_code_from_collection_folder(collection_folder)
}
\arguments{
\item{collection_folder}{Input character vector. This character vector should
corresponding to a collection folder or multiple collection folders. This
character vector must can be named either with 3-letters, 1 letter and
2-digits, or 3-letters and 2-digits. All prefixs must be followed by 8
digits corresponding to the deployment date and 8 digits corresponding to
the date of the last photo in the collection or the date the photos were
collected from the camera.}
}
\value{
A data frame with a \code{site_code} column and a \code{collection_folder}
column.
}
\description{
\code{extract_site_code_from_collection_folder()} extracts the site
code based on the prefix of a collection folder and returns a data frame
with \code{site_code} and \code{collection_folder} columns.
}
\examples{
library(GrazingCameratraps)

extract_site_code_from_collection_folder("WCS_04192019_05212019")

}
