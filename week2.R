## week 2

## Getting data from MySQL

## http://dev.mysql.com/doc/employee/en/sakila-structure.html
## http://dev.mysql.com/doc/refman/5.7/en/installing.html
## on a mac: install.packages("RMySQL")
## on windows: http://biostat.mc.vanderbilt.edu/wiki/Main/RMySQL
## http://www.ahschulz.de/2013/07/23/installing-rmysql-under-windows
install.packages("RMySQL", type = "source")
library(RMySQL)
con <- dbConnect(MySQL(), host="127.0.0.1", port= 3306, user="ebratt",
                 password = "pass", dbname="test")
rm(list=ls())
## http://genome.ucsc.edu/
ucscDb <- dbConnect(MySQL(), username="genome", host="genome-mysql.cse.ucsc.edu")
result <- dbGetQuery(ucscDb, "show databases;")
dbDisconnect(ucscDb)
result
hg19 <- dbConnect(MySQL(), user="genome", db="hg19",
                  host="genome-mysql.cse.ucsc.edu")
allTables <- dbListTables(hg19)
length(allTables)
allTables[1:5]
dbListFields(hg19,"affyU133Plus2")
dbGetQuery(hg19, "select count(*) from affyU133Plus2")
affyData <- dbReadTable(hg19, "affyU133Plus2")
head(affyData)
query <- dbSendQuery(hg19, "select * from affyU133Plus2 where misMatches between 1 and 3")
affyMis <- fetch(query); quantile(affyMis$misMatches)
affyMisSmall <- fetch(query, n=10); dbClearResult(query);
dim(affyMisSmall)
affyMisSmall[1:5]
dbDisconnect(hg19)
## http://cran.r-project.org/web/packages/RMySQL/RMySQL.pdf
## http://www.pantz.org/software/mysql/mysqlcommands.html
## http://www.r-bloggers.com/mysql-and-r/

## Getting data from HDF5 ("hierarchical data format")
## http://www.hdfgroup.org/
source("http://bioconductor.org/biocLite.R")
biocLite("rhdf5")
library(rhdf5)
created = h5createFile("example.h5")
created
## for a tutorial go to http://www.bioconductor.org/packages/release/bioc/vignettes/rhdf5/inst/doc/rhdf5.pdf
created = h5createGroup("example.h5", "foo")
created = h5createGroup("example.h5", "baa")
created = h5createGroup("example.h5", "foo/foobaa")
h5ls("example.h5")
A = matrix(1:10,nr=5,nc=2)
h5write(A, "example.h5", "foo/A")
B = array(seq(0.1, 2.0, by=0.1), dim=c(5,2,2))
attr(B, "scale") <- "liter"
h5write(B, "example.h5", "foo/foobaa/B")
h5ls("example.h5")
df <- data.frame(1L:5L, seq(0,1,length.out=5),
                c("ab","cde","fghi","a","s"), stringsAsFactors=FALSE)
h5write(df, "example.h5", "df")
h5ls("example.h5")
readA <- h5read("example.h5", "foo/A")
readB <- h5read("example.h5", "foo/foobaa/B")
readdf <- h5read("example.h5", "df")
readA
h5write(c(12,13,14), "example.h5", "foo/A", index=list(1:3,1)) ## index lets you write to chunks
h5read("example.h5", "foo/A")
h5ls("example.h5")
## go to http://www.hdfgroup.org/HDF5/

## reading data from the web (scraping and API's)
## for more info visit http://en.wikipedia.org/wiki/Web_scraping
## check the web site's terms of service
## sometimes you can get your IP address blocked if you hit too many pages
con <- url("http://scholar.google.com/citations?user=HI-I6C0AAAAJ&hl=en")
htmlCode = readLines(con)
close(con)
htmlCode
library(XML)
url <- "http://scholar.google.com/citations?user=HI-I6C0AAAAJ&hl=en"
html <- htmlTreeParse(url, useInternalNodes=T)
title <- xpathSApply(html, "//title", xmlValue)
num_cited <- xpathSApply(html, "//td[@class='gsc_a_c']", xmlValue)
## GET from the httr package instead of XML package
library(httr); html2 = GET(url)
content2 <- content(html2, as="text")
parsedHtml <- htmlParse(content2, asText=TRUE)
xpathSApply(parsedHtml, "//title", xmlValue)
pg1 <- GET("http://httpbin.org/basic-auth/user/passwd")
pg1
pg2 <- GET("http://httpbin.org/basic-auth/user/passwd",
           authenticate("user", "passwd"))
pg2
names(pg2)
## using handles
google = handle("http://google.com")
pg1 = GET(handle=google, path="/")
pg2 = GET(handle=google, path="search")
## check out R bloggers at http://www.r-bloggers.com/?s=Web+Scraping
## or the help file at http://cran.r-project.org/web/packages/httr/httr.pdf
# get blogger urls with XML:
library(RCurl)
library(XML)
library(jsonlite)
rm(list=ls())
script <- getURL("www.r-bloggers.com")
doc <- htmlParse(script)
li <- getNodeSet(doc, "//ul[@class='xoxo blogroll']//a")
urls <- sapply(li, xmlGetAttr, "href")
# get ids for those with only 2 slashes (no 3rd in the end):
id <- which(nchar(gsub("[^/]", "", urls))==2)
slash_2 <- urls[id]
urls
id
slash_2

## getting data using API's
## https://dev.twitter.com/docs/api/1/get/blocks/blocking
## https://dev.twitter.com/apps
myapp <- oauth_app("twitter",
                 key="sh7j1GNiGPnWNWKHgrM5Eg", 
                 secret="3xNUf28HIfww6dVFpZft5bXYdGt4JMl1BP4tGo")
sig <- sign_oauth1.0(myapp,
                     token="104298247-9Rbq0e8VCeWuX6krUcCorid68hlxgmGiOX1IcyKg",
                     token_secret="CMU11rqviWhvGkGWn902D2EuArPLkp28OdLXPp42Inbc3")
homeTL <- GET("https://api.twitter.com/1.1/statuses/home_timeline.json", sig)
json1 <- content(homeTL)
json2 <- jsonlite::fromJSON(toJSON(json1))
json2[1,1:4]
json2[2,1:4]
json2[3,1:4]
json2[,4]
## https://dev.twitter.com/docs/api/1.1/get/search/tweets
## https://dev.twitter.com/docs/api/1.1/overview


## reading data from other sources; typically just google "<data type> R package"
## REMEMBER TO CLOSE CONNECTIONS!!!
