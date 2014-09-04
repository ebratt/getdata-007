## Week 1 - part 2
## reading JSON
rm(list=ls())
install.packages("jsonlite")
install.packages('httr')
require(jsonlite)
fileURL <- "https://api.github.com/users/ebratt/repos"
jsonData <- fromJSON(fileURL)
names(jsonData)
str(jsonData)
head(jsonData)
names(jsonData$owner)
jsonData$owner$login
# convert data frames to JSON and back to data frames
myjson <- toJSON(iris, pretty=TRUE)
cat(myjson)
iris2 <- fromJSON(myjson)
head(iris2)

## using data.table package
## faster at subsetting, grouping, and updating
## like small databases local to the environment
rm(list=ls())
install.packages("data.table")
library(data.table)
DF <- data.frame(x=rnorm(9), y=rep(c("a","b","c"), each=3), z=rnorm(9))
head(DF,3)
DT <- data.table(x=rnorm(9), y=rep(c("a","b","c"), each=3), z=rnorm(9))
head(DT,3)
tables()
DT[2,]
DT[c(2,3)]
DT[,c(2,3)] ## subsetting columns doesn't work the same way as data.frame
DT[,x] ## use named column variables to access the columns
DT[, list(mean(x), sum(z))]
DT[, w:=z^2] ## adding columns is fast
DT ## instead of creating a new copy, the existing data.table is updated, so you 
   ## need to be REALLY careful because the data.table is mutable
DT2 <- copy(DT) ## immutable way is to create a copy
DT3 <- DT
DT[, w:=NULL] ## dropping columns is fast
str(DT)
str(DT2) ## the copy still has the extra column
str(DT3) ## the pointer looks like the original
tables()
DT[,tmp:={tmp <- (x+z); log2(tmp+5)}] ## remember that the last step is what is executed
tables()
DT
DT[, a:=x>0]
DT
DT[,b:=mean(x+tmp),by=a] ## "by" is for grouping
DT
rm(list=ls())
set.seed(123)
DT <- data.table(x=sample(letters[1:3], 1E5, TRUE))
DT[, .N, by=x] ## .N counts the number of times 
rm(list=ls())
DT <- data.table(x=rep(c("a","b","c"), each=100), y=rnorm(300))
setkey(DT, x)
head(DT)
str(DT)
tables()  ## now KEY is defined as the 'x' column, which allows you to join to other data.tables
rm(list=ls())
DT1 <- data.table(x=c('a','b','c','dt1'), y=1:4)
DT2 <- data.table(x=c('a','b','dt2'), z=5:7)
setkey(DT1, x)
setkey(DT2, x)
merge(DT1, DT2) ## no need to define how the merge/join happens if you have the same key column! Implicit inner join...
rm(list=ls())
big_df <- data.frame(x=rnorm(1E6), y=rnorm(1E6))
file <- tempfile()
write.table(big_df, file=file, row.names=FALSE, col.names=TRUE, sep="\t", quote=FALSE)
system.time(fread(file))  ## fread is fast-read...must faster than read.table!
system.time(read.table(file, header=TRUE, sep="\t"))  ## much slower than fread

## quiz 1
## question 1
rm(list=ls())
help(download.file)
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv"
if (!file.exists("./quiz1")) 
    dir.create("./quiz1")
setwd("./quiz1")
destfile <- "housing_idaho.csv" ## destination file name
if (Sys.info()[['sysname']] == 'Windows') {
    download.file(url=url, destfile=destfile) ## download the file
} else {
    download.file(url=url, destfile=destfile, method="curl") ## download the file
}
DT <- data.table(fread(destfile))  ## fast-read the file into a data table
DT[,sum(.N),VAL>23]  ## add the Number of occ's where VAL>$999,999

## question 2
DT[,.N,by=FES] ## count the number of family and employment status groups

## question 3
rm(list=ls())
library(xlsx)
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FDATA.gov_NGAP.xlsx"
destfile <- "ngap.xlsx"
if (Sys.info()[['sysname']] == 'Windows') {
    download.file(url=url, destfile=destfile, mode="wb")
} else {
    download.file(url=url, destfile=destfile, method="curl")
}
dat <- read.xlsx(destfile, 
                 sheetIndex=1,
                 rowIndex=c(18,19,20,21,22,23), 
                 colIndex=c(7,8,9,10,11,12,13,14,15))
sum(dat$Zip*dat$Ext,na.rm=T) 

## question 4
rm(list=ls())
library(XML)
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Frestaurants.xml"
destfile <- "restaurants.xml"
if (Sys.info()[['sysname']] == 'Windows') {
    download.file(url=url, destfile=destfile)
} else {
    download.file(url=url, destfile=destfile, method="curl")
}
doc <- xmlTreeParse(destfile, useInternalNodes=TRUE)  ## parse the XML
top <- xmlRoot(doc)  ## get the root node
zipcodes <- xpathSApply(top, "//zipcode", xmlValue)  ## get the zipcodes
DT <- data.table(zipcodes)  ## createa  data table for aggregation
DT[, .N, by=zipcodes][zipcodes==21231]  ## group by zipcode and select for 21231

## question 5
rm(list=ls())
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06pid.csv"
destfile <- "communities_idaho.csv"
if (Sys.info()[['sysname']] == 'Windows') {
    download.file(url=url,destfile=destfile)
} else {
    download.file(url=url,destfile=destfile,method="curl")
}
DT <- data.table(fread(destfile))
DT[, mean(pwgtp15),by=SEX]

rm(list=ls())
