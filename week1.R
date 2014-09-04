## class.coursera.org/getdata-007 
## week 1
## 2014-09-02
## Eric Bratt

## documenting the processing steps is the most important part 
## its all about taking raw data and processing it into tidy data
## meta data describes the data (code book)
## https://github.com/jtleek/datasharing

raw_data <- list(
    a = data.frame(x = 1:10, a = runif(10)),
    b = data.frame(x = 1:10, b = runif(10)),
    c = data.frame(x = 1:10, c = runif(10))
)
tidy_data <- join_all(raw_data, "x")

## include the software version in the abstract

## using R to download files (so that the downloading process can be included
## in the process script)

## clear out the environment
rm(list=ls())

## if the data directory does not exist, create it
if (!file.exists("data")) {
    dir.create("data")
}

## set the working directory to the data directory
## setwd("./data")

## you can use download.file() to download data from the internet
## don't need to use curl if you're on windows; only on a mac
fileURL <- "https://data.baltimorecity.gov/api/views/dz54-2aru/rows.csv?accessType=DOWNLOAD"
download.file(fileURL, destfile="./data/cameras.csv")
list.files("./data")
dateDownloaded <- date()
dateDownloaded

## read the data into a data frame
raw_data <- read.csv("./data/cameras.csv")
str(raw_data)
head(raw_data)

## reading MS Excel files (most widely-used format)
fileURL <- "https://data.baltimorecity.gov/api/views/dz54-2aru/rows.xlsx?accessType=DOWNLOAD"
download.file(fileURL, destfile="./data/cameras.xlsx")
list.files("./data")
dateDownloaded <- date()
dateDownloaded

## read the data into a data frame
library(xlsx)
raw_data_xlsx <- read.xlsx("./data/cameras_good.xlsx", sheetIndex=1, header=TRUE)
str(raw_data_xlsx)
head(raw_data_xlsx)
colIndex <- 2:3
rowIndex <- 1:4
cameraDataSubSet <- read.xlsx("./data/cameras_good.xlsx", sheetIndex=1, colIndex=colIndex, rowIndex=rowIndex)
str(cameraDataSubSet)
head(cameraDataSubSet)
## check out XLConnect vignette; for this class we will store as .csv

## reading XML files
library(XML)
fileURL <- "http://www.w3schools.com/xml/simple.xml"
doc <- xmlTreeParse(fileURL, useInternal=TRUE)
rootNode <- xmlRoot(doc)
xmlName(rootNode)
names(rootNode)
rootNode[[1]]
rootNode[[1]][[1]] ## name element
rootNode[[1]][[2]] ## price element
xmlSApply(rootNode, xmlValue)
## use XPath to read the data
## http://www.stat.berkeley.edu/~statcur/Workshop2/Presentations/XML.pdf
names <- xpathSApply(rootNode, "//name", xmlValue) ## gives a list of names
prices <- xpathSApply(rootNode, "//price", xmlValue) ## gives a list of prices

## parsing HTML with xpath
fileURL <- "http://espn.go.com/nfl/team/_/name/bal/baltimore-ravens"
doc <- htmlTreeParse(fileURL, useInternal=TRUE)
active <- xpathSApply(doc, "//li[@class='active']", xmlValue)
teams <- xpathSApply(doc, "//li[@class='team-name']", xmlValue)
expandable <- xpathSApply(doc, "//li[@class='expandable']", xmlValue)
active
teams
expandable

## parsing xml with xpath on a known file
fileURL <- "C:\\Users\\ebratt\\Dropbox\\xactly\\ge capital\\FLEET\\20140811 Migration to Production\\sandbox3_B1\\sbox_PLAN\\PLAN1.xml"
fileURL
doc <- xmlTreeParse(fileURL, useInternal=TRUE)
rootNode <- xmlRoot(doc)
names <- xpathSApply(rootNode, "//imp:Name", xmlValue)
types <- xpathSApply(rootNode, "//imp:Type", xmlValue)
entities <- xpathSApply(rootNode, "//imp:EntityType", xmlValue)
rows <- xpathSApply(rootNode, "//imp:RowNum", xmlValue)
values <- xpathSApply(rootNode, "//imp:Value", xmlValue)
names
types
entities
max(rows)
values[1:100]

## run xml tutorials for short and long
## read the guide to XML package
b <- newXMLNode("bob", 
                namespace = c(r = "http://www.r-project.org",
                              omg = "http://www.omegahat.org"))
cat(saveXML(b), "\n")
addAttributes(b, a = 1, b = "xyz", "r:version" = "2.4.1", "omg:len" = 3)
cat(saveXML(b), "\n")
removeAttributes(b, "a", "r:version")
cat(saveXML(b), "\n")
removeAttributes(b, "a")
cat(saveXML(b), "\n")
names(xmlAttrs(b))
removeAttributes(b, .attrs = names(xmlAttrs(b)))
cat(saveXML(b), "\n")
addChildren(b, newXMLNode("e1", "Red", "Blue", "Green", 
                          attrs = c(lang = "en")))
k <- lapply(letters, newXMLNode)
addChildren(b, kids = k)
cat(saveXML(b), "\n")
removeChildren(b, "a", "b", "c", "z")
cat(saveXML(b), "\n")
# can mix numbers and names
removeChildren(b, 2, "e") # d and e
cat(saveXML(b), "\n")
i <- xmlChildren(b)[[5]]
xmlName(i)
# have the identifiers
removeChildren(b, kids = c("m", "n", "q"))
cat(saveXML(b), "\n")
x <- xmlNode("a",
                 xmlNode("b", "1"),
                 xmlNode("c", "1"),
             "some basic text")
v <- removeChildren(x, "b")
# remove c and b
cat(saveXML(x), "\n")
v
cat(saveXML(x), "\n")
isXMLString(x)
isXMLString(b)
isXMLString(v)
isXMLString(i)
isXMLString("<a><b>c</b></a>")
xmlParseString("<a><b>c</b></a>")
isXMLString(xml("foo"))

## read an HTML table
# u = "http://en.wikipedia.org/wiki/World_population"
u <- "http://en.wikipedia.org/wiki/List_of_countries_by_population"
tables <- readHTMLTable(u)
names(tables)
tables[[2]]
tmp <- tables[[2]]
doc <- htmlParse(u)
tableNodes <- getNodeSet(doc, "//table")
tb <- readHTMLTable(tableNodes[[2]])
tb
# Let's try to adapt the values on the fly.
# We'll create a function that turns a th/td node into a val
tryAsInteger <- function(node) {
    val <- xmlValue(node)
    ans <- as.integer(gsub(",", "", val))
    if(is.na(ans))
        val
    else
        ans
}
tb <- readHTMLTable(tableNodes[[2]], elFun = tryAsInteger,
                    colClasses = c("character", rep("integer", 9)))
tb
zz <- readHTMLTable("http://www.inflationdata.com/Inflation/Consumer_Price_Index/HistoricalCPI.aspx")
if(any(i <- sapply(zz, function(x) if(is.null(x)) 0 else ncol(x)) == 14)) {
    # guard against the structure of the page changing.
    zz <- zz[[which(i)[1]]] # 4th table
    # convert columns to numeric. Could use colClasses in the call to readHTMLTable()
    zz[-1] <- lapply(zz[-1], function(x) as.numeric(gsub(".*", "", as.character(x))))
    matplot(1:12, t(zz[-c(1, 14)]), type = "1")
}

test <- function() {
    if(require(RCurl) && url.exists("http://www.omegahat.org/RCurl/testPassword/table.html")) {
    tt <- getURL("http://www.omegahat.org/RCurl/testPassword/table.html", userpwd = "bob:duncantl")
    readHTMLTable(tt)
    }
}
test
str(test)
url.exists("http://www.omegahat.org/RCurl/testPassword/table.html")

## tutorials
## http://www.omegahat.org/RSXML/shortIntro.pdf
rm(list=ls())
fileURL <- "http://www.w3schools.com/xml/simple.xml"
doc <- xmlTreeParse(fileURL, useInternal=TRUE)
src <- xpathApply(doc, "//a[@href]", xmlGetAttr, "href")
str(src)
rootNode <- xmlRoot(doc)
xmlValue(rootNode)
xmlChildren(rootNode)[[1]]
xmlChildren(rootNode)[2:3]
length(xmlChildren(rootNode))
xmlSize(rootNode)
rootNode[1:3]
xmlSApply(rootNode, xmlGetAttr, "id")
while(!is.null(rootNode)) {
    children <- xmlChildren(rootNode)
    siblings <- getSibling(children)
}
children

## creating XML
rm(list=ls())
node <- newXMLNode("A")
sapply(c("X", "Y", "Z", "X", "Y"),
       newXMLNode, parent = node)
cat(saveXML(node))
xmlAttrs(node)["src"] <- "http://www.omegahat.org"
cat(saveXML(node))

## use XPath to read the data
## http://www.stat.berkeley.edu/~statcur/Workshop2/Presentations/XML.pdf
names <- xpathSApply(rootNode, "//name", xmlValue) ## gives a list of names

## http://www.omegahat.org/RSXML/Tour.pdf
## http://www.stat.berkeley.edu/~statcur/Workshop2/Presentations/XML.pdf
fileURL <- "http://www.w3schools.com/xml/simple.xml"
doc <- xmlTreeParse(fileURL, useInternal=TRUE)
rootNode <- xmlRoot(doc)
head(rootNode)
xmlName(rootNode)
xmlAttrs(rootNode)
xmlSize(rootNode)
xmlChildren(rootNode)[[1]]
xmlNamespaceDefinitions(rootNode)

# Get data for 2011
query <- c("cbt" = "'cognitive behavior therapy' OR 'cognitive behavioral therapy' OR 'cognitive therapy' AND 2011[DP]")
pub.efetch <- searchPubmed(query)
cbt_2011 <- extractJournal()

# Get data for 2010
query <- c("cbt" = "'cognitive behavior therapy' OR 'cognitive behavioral therapy' OR 'cognitive therapy' AND 2010[DP]")
pub.efetch <- searchPubmed(query)
cbt_2010 <- extractJournal()

# Get data total data for all years
query <- c("cbt" = "'cognitive behavior therapy' OR 'cognitive behavioral therapy' OR 'cognitive therapy'")
pub.efetch <- searchPubmed(query)
cbt_any <- extractJournal()