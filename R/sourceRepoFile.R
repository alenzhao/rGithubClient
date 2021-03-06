## AUTHOR: BRIAN M. BOT
#####

setMethod(
  f = "sourceRepoFile",
  signature = c("character", "character"),
  definition = function(repository, repositoryPath, ...){
    return(sourceRepoFile(getRepo(repository, ...), repositoryPath))
  }
)


setMethod(
  f = "sourceRepoFile",
  signature = c("githubRepo", "character"),
  definition = function(repository, repositoryPath, ...){
    
    ## MAKE SURE repositoryPath EXISTS
    if( !all(repositoryPath %in% repository@tree$path) ){
      stop("repositoryPath does not exists within this repository - cannot source")
    }
    
    ## GRAB THE sha VALUES FROM THESE PATHS AND BUILD URLS FOR THEIR BLOBS
    theseShas <- repository@tree$sha[match(repositoryPath, repository@tree$path)]
    constructedURLs <- paste("https://api.github.com/repos", repository@user, repository@repo, "git/blobs", theseShas, sep="/")

    for (url in constructedURLs) {
      txt <- getURL(url, .opts=list(httpHeader = c(Accept="application/vnd.github.raw"), low.speed.time=60, low.speed.limit=1, connecttimeout=300, followlocation=TRUE, ssl.verifypeer=TRUE, verbose = FALSE))
      source(file=textConnection(txt), ...)
    }
  }
)

