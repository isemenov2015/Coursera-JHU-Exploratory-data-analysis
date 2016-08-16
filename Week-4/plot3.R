#Script for Week 4 project on JHU/Coursera Exploratory data analysis
#Downloads zip archive with PM 2.5 emissions allover US, loads it into R,
#creates a plot that was specified in a brief
#Needs 'downloader' package from CRAN to be installed
#Needs 'ggplot2' and 'scales' package from CRAN to be installed

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
#SCC <- readRDS("Source_Classification_Code.rds")

#subset data for Baltimore
baltimore <- NEI[NEI$fips == '24510', ]

library(ggplot2)
library(scales)

bp <- ggplot(baltimore, aes(x=factor(year), y=Emissions)) + 
    geom_bar(position = 'dodge', stat = 'identity') + 
    facet_grid(type ~ ., scales = 'free_y') +
    ggtitle('Baltimore PM 2.5 annual emissions by types') + xlab('Year') +
    ylab('PM 2.5 emissions, tons')

ggsave('plot3.png', plot = bp, device = 'png', width = 5, height = 8, units = 'in')