# code for importing, sorting, and plotting maps of publications in AmNat 1900-2015 used by Bruna and Mundim
# in talk at Evolution 2015 meeting in Brazil. Data are available at: ---------------

library(dplyr)
library(tidyr)
library(ggplot2)
#library(RColorBrewer)
library(grid)
library(gridExtra)
library(RGraphics)
library(rworldmap)

setwd("~/Dropbox/Bruna.Mundim_ASN_2015_Talk")


rm(list=ls())
#LOAD THE NECESSARY FUNCTIONS

# LOAD THE DATA 
AMNAT<-read.csv("AmNatAll.csv", dec=".", header = TRUE, sep = ",", check.names=FALSE )

# BREAK IT UP INTO THE DIFFERENT DATASETS OF INTEREST
# all the papers
ALL<-select(AMNAT, country, country.code, count.total)
names(ALL)[3]<-"count" #rename the column
# all the tropical papers
TROP<-select(AMNAT, country, country.code, count.trop)
names(TROP)[3]<-"count" #rename the column
# all the interactions papers
INT<-select(AMNAT, country, country.code, count.int)
names(INT)[3]<-"count" #rename the column
# all the papers tropical x interactions
TXI<-select(AMNAT, country, country.code, count.txi)
names(TXI)[3]<-"count" #rename the column

# Select the dataset you want to map
 DATA<-ALL
#  DATA<-INT
# DATA<-TROP
# DATA<-TXI

DATA<-arrange(DATA, count)  #Arrange them from low to high - easier to see who is high and low

# If you need to clean up country names you do it with this section
# DATA$Country.Name<- as.character(DATA$Country.Name)
# DATA$Country.Name[DATA$Country.Name == "SOUTH.AFRICA"] <- "South Africa"
# DATA$Country.Name<- as.factor(DATA$Country.Name)

# making the maps: First map to the whole globe...
sPDF <- joinCountryData2Map(DATA, joinCode = "ISO3", nameJoinColumn = "country.code") 
mapCountryData(sPDF, nameColumnToPlot="count") #Maps your variable of interest into the map of the world


# ...then reduce to region if you want to. For example, how to just plot to LATAM
# with HT to http://stackoverflow.com/questions/28838866/mapping-all-of-latin-america-with-rworldmap/28863992#28863992)
# sPDFmyCountries <- sPDF[sPDF$NAME %in% DATA$country,] #select out your countries


# use the bbox to define xlim & ylim
#mapCountryData(sPDF, nameColumnToPlot="articles", xlim=bbox(sPDFmyCountries)[1,], ylim=bbox(sPDFmyCountries)[2,])

# The legend style and break points are defined in this section
# catMethod: ”pretty”, ”fixedWidth”, ”diverging”,”logFixedWidth”,”quantiles”,”categorical”,
# or a numeric vector defining breaks.
# breaks<-c(0,40,100,200,300,400,500,600,700,800)
 breaks<-seq(0, 5400, by = 10) #ALL
# breaks<-seq(0, 400, by = 10) #INT
# breaks<-seq(0, 150, by = 5) #TROP
# breaks<-seq(0, 35, by = 5) #TROP x INT
# breaks<-c(seq(0, 1500, by = 100),3500)

# OR BETTER YET: If you wanted just to display the boundaries of the countries you have 
# (i.e. if you had all of the Latin American countries in your data) you could do as follows, note you need to 
# chnage my sPDF to sPDFmyCOuntries as above in filtering line:
AMNAT<-mapCountryData(sPDF, nameColumnToPlot="count", catMethod=breaks, addLegend=FALSE,
               colourPalette="heat", borderCol="black", mapTitle = "   ", lwd=1.25) #numCats=30 lwd=lines width


do.call( addMapLegend, c( AMNAT
                          , legendLabels="all"
                          , legendWidth=0.5 
                          ,legendMar=7))  

# title: "American Nat Articles \n(1900-2015)"

###BUBBLES
mapDevice()


mapBubbles( dF=sPDF)()
,nameZSize="count"
)




mtext("Figure 5",side=1,line=4, font=2, cex=1)