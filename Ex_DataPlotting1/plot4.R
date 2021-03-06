#Script for Week 1 project on JHU/Coursera Exploratory data analysis
#Downloads zip archive with power consumption data from a given location, loads it into R,
#creates a plot that was specified in a brief
#Needs 'downloader' package from CRAN to be installed
#Needs 'lubridate' package from CRAN to be installed

getsets <- function(furl = '') {
# downloads .zip file from location specified in furl,
# unzips data and removes downloaded archive from disk
    library(downloader)
    zipfile <- 'dfile.zip'
    download(fileurl, dest = zipfile, mode = 'wb')
    unzip(zipfile)
    unlink(zipfile)
}

fileurl <- 'https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip'
#debug Uncomment function call before submitting
getsets(fileurl)
#end debug

#read data to a big data frame
dset <- read.table('household_power_consumption.txt', sep=';', stringsAsFactors = FALSE, 
                   na.strings = '?', header = TRUE)

#convert Date field to POSIXct format
library(lubridate)
dset$Date <- dmy(dset$Date)

#need only data for 2 particular dates on a histogram
subdata <- c(ymd('2007-02-01'), ymd('2007-02-02'))
force_tz(subdata, 'UTC')

#subset data frame for selected dates
smallset <- subset(dset, Date %in% subdata)

#clean working space, big data frame not necessary any more
rm(dset)

#combine date and time into a single vector
datetime <- as.POSIXct(paste(smallset$Date, smallset$Time), format="%Y-%m-%d %H:%M:%S")

#initialize graphic device
png(filename = 'plot4.png', width = 480, height = 480)

#save previous MFCOL setting and set graphic system for plotting 4 graphs in one image
old_par <- par('mfcol')
par(mfcol = c(2, 2))

#draw plot 1
plot(dtime, smallset$Global_active_power, type = 'l', 
     ylab = 'Global Active Power', xlab = '')
#draw plot 2
plot(datetime, smallset$Sub_metering_1, type = 'l', ylab = 'Energy sub metering', xlab = '')
points(datetime, smallset$Sub_metering_2, type = 'l', col = 'red')
points(datetime, smallset$Sub_metering_3, type = 'l', col = 'blue')
legend('topright', legend = c('Sub_metering_1', 'Sub_metering_2', 'Sub_metering_3'), 
       col = c('black', 'red', 'blue'), lwd = 1, cex = 0.8, bty = 'n')
#draw plot 3
plot(datetime, smallset$Voltage, type = 'l', ylab = 'Voltage')
#draw plot 4
plot(datetime, smallset$Global_reactive_power, type = 'l', ylab = 'Global_reactive_power')

#restore MFCOL setting
par(mfcol = old_par)

#close graphic device
dev.off()
