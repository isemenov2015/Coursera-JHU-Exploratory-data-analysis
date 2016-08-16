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
SCC <- readRDS("Source_Classification_Code.rds")

#subset coal rows from keyindex dataset
motorscc <- SCC[grep('vehicle', tolower(SCC$Short.Name)), ]

#subset main dataframe for Baltimore
mNEI <- NEI[NEI$fips == '24510',]

#merge two datasets by SCC key
mNEI <- merge(mNEI, motorscc, by = 'SCC')

#sum Emissions by year
aggrTotal <- aggregate(Emissions ~ year, mNEI, sum)

library(ggplot2)

#initialize graphic device
png(filename = 'plot5.png', width = 640, height = 480)

g <- ggplot(aggrTotal, aes(factor(year), Emissions))
g <- g + geom_bar(stat = 'identity', fill = 'blue') + xlab("Year") + 
    ylab('Total PM 2.5 Emissions')
g <- g + ggtitle('Total motor vehicle Emissions from 1999 to 2008 in Baltimore')
print(g)

#close graphic device
dev.off()