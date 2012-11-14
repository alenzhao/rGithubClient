## source one or more remote .R files
## usage: sfr(repo, "my/special/script.R")
##
## to source into a new environment:
## e <- new.env()
## sfr(repo, "my/special/script.R", local=e)
## e$my_function(e$my_data)
## attach(e)
## todo: test on SVN or BitBucket URLs
sourceRemote <- function(urls, ...) {
  # question: is there a way to get RCurl to return a "file-like" connection object?
  # maybe it would be better to save code to a temporary file?
  for (url in urls) {
    txt <- getURL(url, .opts=list(httpHeader = c(Accept="application/vnd.github.raw"), low.speed.time=60, low.speed.limit=1, connecttimeout=300, followlocation=TRUE, ssl.verifypeer=TRUE, verbose = FALSE))
    source(file=textConnection(txt), ...)
  }
}

gistURL <- function(gist) {
  # inspired by the function runGist, from shiny:
  # https://github.com/rstudio/shiny/blob/master/R/shiny.R
  # todo: use GIT API to get individual parts of multi-part GISTs.
  if (length(gist)==0)
    character(length=0)
  else if (length(gist) > 1)
    # handle multiple inputs
    sapply(gist, gistURL, USE.NAMES=FALSE)
  else if (is.numeric(gist) || grepl('^[0-9a-f]+$', gist))
    sprintf("https://raw.github.com/gist/%s/", gist)
  else if (grepl("^https://gist.github.com/\\d+/?", gist, ignore.case=TRUE)) {
    id <- gsub("^https://gist.github.com/(\\d+)/?", "\\1", gist, ignore.case=TRUE)
    sprintf("https://raw.github.com/gist/%s/", id)
  }
  else if (grepl("^https://raw.github.com/gist/.*", gist, ignore.case=TRUE))
    gist
  else
    stop('Unrecognized gist identifier format')
}

## source a Gist file into the global environment
## or one specified using the parameter "local"
## (see sourceRemote and base::source)
sourceGist <- function(gist, ...) {
  sourceRemote(gistURL(gist), ...)
}
