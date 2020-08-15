
data.join <- function() {
	library(data.table)

	# Pass directory as var
	directory <- "~/Desktop/data_by_station/"

	# load stations
	stations <- read.csv(paste(directory, "stations", sep=""), sep=";")
	# por cada estación
	for(i in 1:nrow(stations)) {
		station.id <- stations$id_station[i]
		print(paste("Joining station:", station.id))
		meteo <- fread(paste(directory, station.id, "/meteo_", station.id, sep=""), sep=",")
		traffic <- fread(paste(directory, station.id, "/traffic_", station.id, sep=""), sep=",")
		no2 <- fread(paste(directory, station.id, "/no2_", station.id, sep=""), sep=",")
		festivos <- fread(paste(directory, "festivos_hourly.csv", sep=""), sep=",")

		dataToMerge <- list(meteo, traffic, no2, festivos)

		ozono.directory <- paste(directory, station.id, "/o3_", station.id, sep="")
		if(file_test("-f", ozono.directory)) {
			ozono <- fread(ozono.directory, sep=",")
			ozono$timestamp <- NULL # para que no entre en conflicto con el de no2
			dataToMerge <- list(meteo, traffic, no2, festivos, ozono)
		}
		# merge by date
		merged <- Reduce(function(x, y) merge(x, y, by="date"), dataToMerge)

		# remove bad data
		merged <- na.omit(merged) # debería de haber 0 porque se supone que la limpieza 
								  # se debe hacer de antemano en cada feature
		merged <- merged[validezno2 == "V",] # se quita no2 y o3 no válido
		if(!is.null(merged$validezo3)) {
			merged <- merged[validezo3 == "V",]
		}
		# new time columns
		merged$hour <- hour(as.POSIXct(merged$date))
		merged$month <- month(as.POSIXct(merged$date))
		merged$weekday <- as.POSIXlt(merged$date)$wday + 1

		# poner variables como la lluvia en una medida estándar y no tan pequeña

		# remove columns unused
		merged$timestamp <- NULL
		merged$validezno2 <- NULL
		if(!is.null(merged$validezo3)) {
			merged$validezo3 <- NULL
		}
		#merged$date <- NULL # it depends
		merged$t2 <- merged$"2t"
		merged$"2t" <- NULL  

		# save to file
		output.filename <- paste(directory, station.id, "/merged_", station.id, sep="")
		write.csv(merged, output.filename, row.names=FALSE, quote=FALSE)
		print(paste("Finishing station:", station.id))	
	}
}