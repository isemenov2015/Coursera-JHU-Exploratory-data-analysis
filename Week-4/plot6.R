#Script for Week 4 project on JHU/Coursera Exploratory data analysis
#Downloads zip archive with PM 2.5 emissions allover US, loads it into R,
#creates a plot that was specified in a brief
#Needs 'downloader' package from CRAN to be installed
#Needs 'ggplot2' package from CRAN to be installed
#Uses function multiplot() got from http://www.cookbook-r.com/Graphs/Multiple_graphs_on_one_page_%28ggplot2%29/

getsets <- function(furl = '') {
# downloads .zip file from location specified in furl,
# unzips data and removes downloaded archive from disk
    library(downloader)
    zipfile <- 'dfile.zip'
    download(fileurl, dest = zipfile, mode = 'wb')
    unzip(zipfile)
    unlink(zipfile)
}

# Multiple plot function
#
# Courtesy to http://www.cookbook-r.com/Graphs/Multiple_graphs_on_one_page_%28ggplot2%29/
#
# ggplot objects can be passed in ..., or to plotlist (as a list of ggplot objects)
# - cols:   Number of columns in layout
# - layout: A matrix specifying the layout. If present, 'cols' is ignored.
#
# If the layout is something like matrix(c(1,2,3,3), nrow=2, byrow=TRUE),
# then plot 1 will go in the upper left, 2 will go in the upper right, and
# 3 will go all the way across the bottom.
#
multiplot <- function(..., plotlist=NULL, file, cols=1, layout=NULL) {
    library(grid)
    
    # Make a list from the ... arguments and plotlist
    plots <- c(list(...), plotlist)
    
    numPlots = length(plots)
    
    # If layout is NULL, then use 'cols' to determine layout
    if (is.null(layout)) {
        # Make the panel
        # ncol: Number of columns of plots
        # nrow: Number of rows needed, calculated from # of cols
        layout <- matrix(seq(1, cols * ceiling(numPlots/cols)),
                         ncol = cols, nrow = ceiling(numPlots/cols))
    }
    
    if (numPlots==1) {
        print(plots[[1]])
        
    } else {
        # Set up the page
        grid.newpage()
        pushViewport(viewport(layout = grid.layout(nrow(layout), ncol(layout))))
        
        # Make each plot, in the correct location
        for (i in 1:numPlots) {
            # Get the i,j matrix positions of the regions that contain this subplot
            matchidx <- as.data.frame(which(layout == i, arr.ind = TRUE))
            
            print(plots[[i]], vp = viewport(layout.pos.row = matchidx$row,
                                            layout.pos.col = matchidx$col))
        }
    }
}


#script body

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
mNEI <- NEI[NEI$fips == '24510' | NEI$fips == '06037',]

#merge two datasets by SCC key
mNEI <- merge(mNEI, motorscc, by = 'SCC')

#sum Emissions by year
aggrTotal <- aggregate(Emissions ~ year + fips, mNEI, sum)

library(ggplot2)

#initialize graphic device
png(filename = 'plot6.png', width = 640, height = 640)

g <- ggplot(aggrTotal, 
            aes(x = factor(year), y = Emissions, fill = factor(fips, labels = c('Los Angeles', 'Baltimore'))))
g <- g + geom_bar(stat = 'identity', position = 'dodge') + xlab("Year") + 
    ylab('Total PM 2.5 Emissions') + labs(fill = 'Counties')
g <- g + ggtitle('Annual motor vehicle Emissions comparison in LA county & Baltimore')

g1 <- ggplot(aggrTotal[aggrTotal$fips == '24510',], aes(factor(year), Emissions))
g1 <- g1 + geom_bar(stat = 'identity', fill = 'blue') + xlab("Year") + 
    ylab('Total PM 2.5 Emissions')
g1 <- g1 + ggtitle('Total motor vehicle Emissions from 1999 to 2008 in Baltimore')

g2 <- ggplot(aggrTotal[aggrTotal$fips == '06037',], aes(factor(year), Emissions))
g2 <- g2 + geom_bar(stat = 'identity', fill = 'darkblue') + xlab("Year") + 
    ylab('Total PM 2.5 Emissions')
g2 <- g2 + ggtitle('Total motor vehicle Emissions from 1999 to 2008 in LA County')

multiplot(g1, g2, g, cols=1)

#close graphic device
dev.off()