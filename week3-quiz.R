##week 3 quiz
## question 1
# load required libraries
library(lubridate) # for pretty dates
rm(list=ls())      # clear env var's

# ensure the directory exists
if (!file.exists("./quiz3")) {
    dir.create("./quiz3")
}

# download the file and save to data frame
fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv"
dateDownloaded <- now()
download.file(fileURL, destfile="./quiz3/housing.csv")
housingData <- read.csv("./quiz3/housing.csv")
agricultureLogical <- which(housingData$ACR == 3 & housingData$AGS == 6)
head(agricultureLogical[1:3])

## question 2
install.packages("jpeg")
library(jpeg)      # for image processing
library(lubridate) # for pretty dates
rm(list=ls())      # clear env var's

# ensure the directory exists
if (!file.exists("./quiz3")) {
    dir.create("./quiz3")
}

# download the file and save to data frame
fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fjeff.jpg"
dateDownloaded <- now()
download.file(fileURL, destfile="./quiz3/jeff.jpg", mode="wb")
img <- readJPEG("./quiz3/jeff.jpg", native=TRUE)
if (exists("rasterImage")) {
    plot(1:2, type='n')
    rasterImage(img, 1.2, 1.27, 1.8, 1.73)
}
quantile(img,probs=c(0.3,0.8))

## question 3
# load required libraries
library(dplyr) # for easy data manipulation
rm(list=ls())      # clear env var's

# ensure the directory exists
if (!file.exists("./quiz3")) {
    dir.create("./quiz3")
}

# download the file and save to data frame
fileURL.gdp <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv"
dateDownloaded.gdp <- now()
download.file(fileURL.gdp, destfile="./quiz3/gdp.csv")
data.gdp <- read.csv("./quiz3/gdp.csv")
fileURL.ed <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FEDSTATS_Country.csv"
dateDownloaded.ed <- now()
download.file(fileURL.ed, destfile="./quiz3/ed.csv")
data.ed <- read.csv("./quiz3/ed.csv")

# gdp data has bad rows and cols
data.gdp <- data.gdp[5:194,c(1:2,4:5)]
names(data.gdp) <- c("CountryCode", "Ranking", "Country", "GDP")

# merge the two data frames
data <- merge(data.gdp, data.ed)

# Ranking needs to be numeric
data$Ranking <- as.numeric(as.character(data$Ranking))
sorted <- data[with(data, order(-Ranking)),]
sorted[13, 1:3]

# use dplyr
library(dplyr)
sorted_df <- tbl_df(sorted)
sorted_grouped_df <- group_by(sorted_df, Income.Group)
summarise(sorted_grouped_df, answer = mean(Ranking, na.rm=T))
sorted_df$RankingGroups <- cut(sorted_df$Ranking, breaks=quantile(sorted_df$Ranking, probs=seq(0, 1, 0.20), na.rm=T)) ## groups, or cuts the data
table(sorted_df$RankingGroups,sorted_df$Income.Group)
