read_url <- function(url, ...) {
  on.exit(close(url))
  readLines(url, ...)
}
showConnections()
g <- read_url("http://www.google.com")
showConnections()