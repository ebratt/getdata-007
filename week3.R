## week 3
## Subsetting
rm(list=ls())
set.seed(13435)
X <- data.frame("var1"=sample(1:5),"var2"=sample(6:10),"var3"=sample(11:15))
X
X <- X[sample(1:5),]; X$var2[c(1,3)] = NA
X
X[,1] ## gets the first column
X[,"var1"]
X[1:2,"var2"]
X[(X$var1 <= 3 & X$var3 > 11),]
X[(X$var1 <= 3 | X$var3 > 15),]
X[which(X$var2 >8),]  ## use which() when dealing with NA's
sort(X$var1)
sort(X$var2)
sort(X$var1,decreasing=T)
sort(X$var2,na.last=T)
X[order(X$var1),]
X[order(X$var2),]
X[order(X$var2,X$var3),]

## same thing using plyr package
library(plyr)
arrange(X,var1)
arrange(X,desc(var1))
X$var4 <- rnorm(5) ## add a column
X
Y <- cbind(X, rnorm(5)) ## add a column using cbind (column binding)
Y
Z <- rbind(Y, c(1,2,3,4))
Z

## summarizing data
rm(list=ls())
library(lubridate)
if (!file.exists("./data")) {
    dir.create("./data")
}
fileURL <- "https://data.baltimorecity.gov/api/views/k5ry-ef3g/rows.csv?accessType=DOWNLOAD"
dateDownloaded <- now()
download.file(fileURL, destfile="./data/restaurants.csv")
restData <- read.csv("./data/restaurants.csv")
head(restData,n=3)
tail(restData,n=3)
summary(restData)
str(restData)
quantile(restData$councilDistrict, na.rm=T)
quantile(restData$councilDistrict,probs=c(0.5,0.75,0.9))
table(restData$zipCode,useNA="ifany") ## make a summary table
table(restData$councilDistrict, restData$zipCode)
table(restData$councilDistrict==11, restData$zipCode)
sum(is.na(restData$councilDistrict))
any(is.na(restData$councilDistrict))
all(restData$zipCode > 0)
colSums(is.na(restData))
all(colSums(is.na(restData))==0)
table(restData$zipCode %in% c("21212"))
table(restData$zipCode %in% c("21212", "21213"))
restData[restData$zipCode %in% c("21212", "21213"),]
data(UCBAdmissions)
DF <- as.data.frame(UCBAdmissions)
summary(DF)
## creating cross-tabs
xt <- xtabs(Freq ~ Gender + Admit, data=DF)
xt

## creating multiple two-dimensional tables
warpbreaks$replicate <- rep(1:9, len=54)
xt <- xtabs(breaks ~., data=warpbreaks)
xt

ftable(xt) ## make it more readable

## looking at data sizes
fakeData <- rnorm(1e5)
object.size(fakeData)
print(object.size(fakeData), units="Mb")


## creating new variables
## important for predictions (missingness indicators, cutting-up quant. variables into factors, applying transformations)
rm(list=ls())
fileURL <- "https://data.baltimorecity.gov/api/views/k5ry-ef3g/rows.csv?accessType=DOWNLOAD"
dateDownloaded <- now()
download.file(fileURL, destfile="./data/restaurants.csv")
restData <- read.csv("./data/restaurants.csv")
s1 <- seq(1,10,by=2); s1
s2 <- seq(1,10,length=3); s2
x <- c(1,3,8,25,100); seq(along = x)
## adding custom variables
restData$nearMe <- restData$neighborhood %in% c("Roland Park", "Homeland")
table(restData$nearMe)
## adding flags
restData$zipWrong <- ifelse(restData$zipCode < 0, TRUE, FALSE)
table(restData$zipWrong, restData$zipCode < 0)
restData[restData$zipWrong==TRUE,]
## creating categorical / factor variables out of quantitative variables
restData$zipGroups <- cut(restData$zipCode, breaks=quantile(restData$zipCode)) ## groups, or cuts the data
table(restData$zipGroups) ## zipGroups is a factor variable now
table(restData$zipGroups,restData$zipCode)
## easier / prettier way...
install.packages("Hmisc")
library(Hmisc)
restData$zipGroups <- cut2(restData$zipCode, g=4)
table(restData$zipGroups)
