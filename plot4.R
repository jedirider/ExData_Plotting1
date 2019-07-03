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

#Graph #4: All 4 graphs one page
par(mfcol=c(2,2))

plot(powerData$dateTimeData, as.numeric(as.character(powerData$Global_active_power)),type='l',ylab="Global Active Power", xlab="")

plot(powerData$dateTimeData, as.numeric(as.character(powerData$Sub_metering_1)),type='l', xlab="",ylab ="Energy sub metering")
lines(powerData$dateTimeData, as.numeric(as.character(powerData$Sub_metering_2)),type='l', col='red')
lines(powerData$dateTimeData, powerData$Sub_metering_3,type='l', col="blue")
legend('topright', c("Sub_metering_1","Sub_metering_2","Sub_metering_3"),
       lty=c(1,1,1),col=c("black","red","blue"),bty = "n")

plot(powerData$dateTimeData, as.numeric(as.character(powerData$Voltage)),type='l', 
     ylab="Voltage",xlab="datetime" )

plot(powerData$dateTimeData, as.numeric(as.character(powerData$Global_reactive_power)),type='l', 
     ylab="Global_reactive_power",xlab="datetime" )

dev.copy(png, file = "plot4.png", height = 480, width = 480)
dev.off()