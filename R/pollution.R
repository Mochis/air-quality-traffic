# load data.table
# load no2 all months
# for every station
	# for every pollution month
		# filter no2 and station and add to rbind
	# apply pollutionDayDates2 to rbind result
	# do call rbind
	# write station to csv

pollutionDayDates3 <- function(row) {
	source("~/Desktop/r_scripts/datesFunctions.R")

	anio <- row[[6]]
	mes <- row[[7]]
	dia <- row[[8]]
	index <- 9
	timestamp <- numeric(24)
	date <- numeric(24)
	pollutant <- character(24)
	validez <- character(24)
	for(hora in 1:24) {
		timestamp[hora] = as.numeric(ISOdate(anio, mes, dia, hora))
		date[hora] <- timestampToDate(timestamp[hora], "%Y-%m-%d %H:%M:%S")
		pollutant[hora] = row[[index]]
		validez[hora] = row[[index + 1]]

		index <- index + 2
	}
	if(row[[4]] == 8) {
		return (data.frame(timestamp, date, no2=pollutant, validezno2=validez))
	} else{
		return (data.frame(timestamp, date, o3=pollutant, validezo3=validez))
	}
}

load.pollution <- function(anio, months) {
	sufix <- paste("_mo", anio, ".csv", sep="")
	poll <- NULL
	for(month in months) {
		poll <- rbind(poll, fread(paste(month, sufix, sep=""), sep=";"))
	}
	return(poll)
}

pollution.prepare <- function() {
	library(data.table)
	#source("~/Desktop/r_scripts/dataFunctions.R") # now is here pollutionDayDates3

	anual.months <- c("ene", "feb", "mar", "abr", "may", "jun", "jul", "ago", "sep", "oct", "nov", "dic")

	pmedair <- read.csv("~/Desktop/data_by_station/stations", sep=";")
	pollution18 <- load.pollution(18, anual.months)
	pollution19 <- load.pollution(19, anual.months[1:6])
	pollution <- rbind(pollution18, pollution19)
	pollutants <- data.table(magnitud = c("no2", "o3"), codigo = c(8, 14))

	# for(i in 1:nrow(pmedair)) {
	# 	station.id <- pmedair$id_station[i]
	# 	aux <- pollution[ESTACION == station.id & MAGNITUD == magnitud, ]
	# 	no2 <- do.call("rbind", apply(aux, 1, pollutionDayDates2))
	# 	output.filename <- paste("no2_", station.id, sep="")
	# 	write.csv(no2, output.filename, row.names=FALSE, quote=FALSE)
	# }
	fmt <- "%Y-%m-%d %H"
	for(i in 1:nrow(pmedair)) {
		station.id <- pmedair$id_station[i]
		for(j in 1:nrow(pollutants)){
			magnitud.cod <- pollutants$codigo[j]
			magnitud.name <- pollutants$magnitud[j]
			pollutant.data <- pollution[ESTACION == station.id & MAGNITUD == magnitud.cod, ]
			if(nrow(pollutant.data) > 0) {
				pollutant.normalized <- do.call("rbind", apply(pollutant.data, 1, pollutionDayDates3))
				output.filename <- paste("pollution_generated/", magnitud.name, "_", station.id, sep="")
				write.csv(pollutant.normalized, output.filename, row.names=FALSE, quote=FALSE)
			}		
		}
	}
}