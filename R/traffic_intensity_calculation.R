
load.traffic <- function() {
	traffic <- NULL
	# 2018
	for(month in 1:12) {
		traffic <- rbind(traffic, fread(paste("./traffic_1819/2018_", sprintf("%02d", month), "_traffic", sep=""), sep=","))
		print(paste("Cargado mes", month))
	}
	# 2019
	for(month in 1:6) {
		traffic <- rbind(traffic, fread(paste("./traffic_1819/2019_", sprintf("%02d", month), "_traffic", sep=""), sep=","))
		print(paste("Cargado mes", month))
	}	
	return(traffic)
}

library(data.table)
source("~/Desktop/r_scripts/datesFunctions.R")

distances <- fread("distances.csv", sep=",")
stations <- read.csv("~/Desktop/data_by_station/stations", sep=";")
fmt <- "%Y-%m-%d %H:%M:%S"
dates <- strftime(seq(as.POSIXct("2018-01-01 00:00:00", format=fmt), as.POSIXct("2019-06-30 23:00:00", format=fmt), by=3600))
times <- dateToTimestampUTC(dates, fmt)
traffic <- load.traffic() # el tráfico tiene NAs
traffic.radix <- 1000 + 30
# Por cada estación
for(i in 1:nrow(stations)) {
	station.id <- stations$id_station[i]
	print(paste("Processing station", station.id))
	traffic.id.near <- distances[distance < traffic.radix & air.id == station.id]$traffic.id
	# por cada fecha-hora sumar las intensidades de las espiras en traffic.id.near4
	traffic.filtered <- traffic[id %in% traffic.id.near,]
	traffic.filtered$time <- dateToTimestampUTC(traffic.filtered$date, fmt)
	intensity <- numeric(NROW(times))
	# for(i in 1:NROW(times)) {
	# 	intensity[i] <- sum(traffic.filtered[time == times[i],]$intensidad, na.rm=TRUE)
	# 	# intensity[i] <- sum(traffic.filtered[date == dates[i] & !is.na(intensidad),]$intensidad, na.rm=TRUE)
	# 	print(paste("Index:", i))
	# }
	intensity <- unlist(lapply(times, function(t){sum(traffic.filtered[time == t,]$intensidad, na.rm=TRUE)}))
	intensidades <- data.frame(date=dates, intensity)
	output.filename <- paste("~/Desktop/data_by_station/", station.id, "/traffic_", station.id, sep="")
	write.csv(intensidades, output.filename, row.names=FALSE, quote=FALSE)
	print(paste("Finish processing station", station.id))
}