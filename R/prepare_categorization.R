
prepare.categorization <- function() {
	library(data.table)

	directory <- "~/Desktop/data_by_station/"

	pmedair <- read.csv(paste(directory, "stations", sep=""), sep=";")

	for(i in 1:nrow(pmedair)) {
		station.id <- pmedair$id_station[i]
		print(paste("Categorizing station:", station.id))

		# loading merged data
		data <- fread(paste(directory, station.id, "/merged_", station.id, sep=""), sep=",")

		# categorizing no2 column
		data$no2cat <- cut(data$no2, breaks=c(0, 101, 201, 301, Inf), labels=c("Buena", "Admisible", "Deficiente", "Mala"))

		# save data to new file
		output.filename <- paste(directory, station.id, "/data_station_", station.id, sep="")
		write.csv(data, output.filename, row.names=FALSE, quote=FALSE)

		print(paste("Finishing station:", station.id))
	}
}