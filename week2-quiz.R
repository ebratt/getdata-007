## week 2 quiz
## question 1
rm(list=ls())
library(httr)
library(jsonlite)
library(dplyr)
library(lubridate)
# 1. Find OAuth settings for github:
#    http://developer.github.com/v3/oauth/
oauth_endpoints("github")

# 2. Register an application at https://github.com/settings/applications;
#    Use any URL you would like for the homepage URL (http://github.com is fine)
#    and http://localhost:1410 as the callback url
#
#    Insert your client ID and secret below - if secret is omitted, it will
#    look it up in the GITHUB_CONSUMER_SECRET environmental variable.
client_id <- "39fc58be550e4e2089a0"
client_secret <- "3c9f138fdf7ab7ac2d6be94e9e35853ceb110946"
myapp <- oauth_app("github", key=client_id, secret=client_secret)
# 3. Get OAuth credentials
github_token <- oauth2.0_token(oauth_endpoints("github"), myapp)

# 4. Use API
gtoken <- config(token = github_token)
req <- GET("https://api.github.com/users/jtleek/repos", gtoken)
stop_for_status(req)
dateDownloaded <- now()
json1 <- content(req)
json2 <- jsonlite::fromJSON(toJSON(json1))
dateCreated <- subset(json2, name == "datasharing", select=c(created_at))
dateCreated

## question 2
rm(list=ls())
library(sqldf)
URL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06pid.csv"
download.file(URL, destfile = "./quiz1/acs.csv")
acs <- read.csv("./quiz1/acs.csv")
sqldf("select pwgtp1 from acs where AGEP < 50")

## question 3
sqldf("select distinct AGEP from acs")cte
unique(acs$AGEP)

## question 4
rm(list=ls())
library(XML)
url <- "http://biostat.jhsph.edu/~jleek/contact.html"
lines <- readLines(url)
nums <- c(10,20,30,100) 
for (n in nums) { print(nchar(lines[n])) }

## question 5
rm(list=ls())
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fwksst8110.for"
width <- c(1,9,5,4,4,5,4,4,5,4,4,5,4,4)
length(width)
file <- read.fwf(url,width=width, skip=4)
colnames <- c("skip1","Week","skip2","Nino1+2_SST","Nino1+2_SSTA",
                 "skip3","Nino3_SST","Nino3_SSTA",
                 "skip3","Nino34_SST","Nino34_SSTA",
                 "skip5","Nino4_SST_SSTA","Nino4_SSTA")

length(colnames)
names(file) <- colnames
head(file)
class(file$Nino4_SST_SSTA)
sum(file$Nino3_SST)

