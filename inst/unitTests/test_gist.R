library(RUnit)

test_gistURL <- function() {
  checkEquals( gistURL("12345"), "https://raw.github.com/gist/12345/" )
  checkEquals( gistURL(12345), "https://raw.github.com/gist/12345/" )
  checkEquals(
    gistURL("https://gist.github.com/12345/"),
    "https://raw.github.com/gist/12345/" )
  checkEquals(
    gistURL("https://gist.github.com/12345"),
    "https://raw.github.com/gist/12345/" )
  checkEquals(
    gistURL("https://raw.github.com/gist/12345/"),
    "https://raw.github.com/gist/12345/" )
  checkEquals(gistURL(c()), character(length=0))
}

test_gistURL_multiple <- function() {
  checkEquals(checkNames=FALSE,
    gistURL(c("12345", "23456", "78910111")),
    c("https://raw.github.com/gist/12345/",
      "https://raw.github.com/gist/23456/",
      "https://raw.github.com/gist/78910111/"))
  checkEquals(checkNames=FALSE,
    gistURL(
      c("12345",
        "https://raw.github.com/gist/223344/",
        "https://gist.github.com/778899/")),
      c("https://raw.github.com/gist/12345/",
      "https://raw.github.com/gist/223344/",
      "https://raw.github.com/gist/778899/"))
}
