#Read data file into R
if(!file.exists('data.zip')){
        url<-"http://archive.ics.uci.edu/ml/machine-learning-databases/00235/household_power_consumption.zip"
        
        download.file(url,destfile = "data.zip")
}
unzip("data.zip")
housepower <- read.table("household_power_consumption.txt", header = TRUE, sep=";")

#Separate the data for the two target days, and recombine (I'm sure there is a simpler
#way, but this was the first thing I thought of)
select1 <- subset(housepower, Date == "1/2/2007")
select2 <- subset(housepower, Date == "2/2/2007")
selection <- rbind(select1,select2)

#Create new dataframe with date&time series for graphing
dateTimeData <- paste(selection$Date,selection$Time)
dateTimeData <- strptime(dateTimeData, "%d/%m/%Y %H:%M:%S")
powerData <-cbind(selection, dateTimeData)

#Graph #2: Timeseries
plot(powerData$dateTimeData, as.numeric(as.character(powerData$Global_active_power)),
     type='l',ylab="Global Active Power (Kilowatts)", xlab="")
dev.copy(png, file = "plot2.png", height = 480, width = 480)
dev.off()