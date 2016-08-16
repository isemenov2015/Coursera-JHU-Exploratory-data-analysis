#Script for Week 4 project on JHU/Coursera Exploratory data analysis
#Downloads zip archive with PM 2.5 emissions allover US, loads it into R,
#creates a plot that was specified in a brief
#Needs 'downloader' package from CRAN to be installed

getsets <- function(furl = '') {
# downloads .zip file from location specified in furl,
# unzips data and removes downloaded archive from disk
    library(downloader)
    zipfile <- 'dfile.zip'
    download(fileurl, dest = zipfile, mode = 'wb')
    unzip(zipfile)
    unlink(zipfile)
}

fileurl <- 'https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip'
#debug Uncomment function call before submitting
getsets(fileurl)
#end debug

#read data to a big data frame
NEI <- readRDS('summarySCC_PM25.rds')
SCC <- readRDS("Source_Classification_Code.rds")

#initialize graphic device
png(filename = 'plot1.png', width = 480, height = 480)

#sum Emissions by year
aggrTotal <- aggregate(Emissions ~ year, NEI, sum)

#create vector for plotting
plotv <- aggrTotal$Emissions
names(plotv) <- aggrTotal$year

barplot(plotv, col = 'red')
#add title
title(main = 'Annual PM 2.5 emission in US', ylab = 'PM 2.5 emission, tons',
      xlab = 'Years')

#close graphic device
dev.off()