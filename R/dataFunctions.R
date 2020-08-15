mezcla <- function() {
	# create empty data-frame. A data-frame row is a list
	col_festivos <- integer(nrow(quarterTimestampDate2018))
	bb <- as.Date(festivos$dia, "%d/%m/%y")
	tryCatch({
		for(i in 1:NROW(col_festivos)-1) {
			#y <- (i%/%97) + 1
			y <- which(bb == as.Date(quarterTimestampDate2018$date[i]))
			col_festivos[i] = festivos$festivo_number[y]
		}
	}, error = function(e) {print(e); print(paste("error i: ", i))})
	return (data.frame(quarterTimestampDate2018, col_festivos))
}

consulta <- function(x) {
	i = which(bb == as.Date(x))
	return (festivos$festivo_number[i])
}

pollutionDayDatesOld <- function(row) {
	mes <- row$MES
	dia <- row$DIA
	index <- 10
	timestamp <- numeric(24)
	valor <- character(24)
	validez <- character(24)
	for(hora in 1:25) {
		timestamp[hora] = as.numeric(ISOdate(2018, mes, dia, hora))
		valor[hora] = row[, index][[1]]
		validez[hora] = row[, index + 1][[1]]

		index <- index + 2
	}

	return (data.frame(timestamp, valor, validez))
}

pollutionDayDates <- function(row) {
	mes <- row$MES
	dia <- row$DIA
	index <- 9
	timestamp <- numeric(24)
	date <- numeric(24)
	no2 <- character(24)
	validez <- character(24)

	for(hora in 1:24) {
		timestamp[hora] = as.numeric(ISOdate(2018, mes, dia, hora))
		date[hora] <- timestampToDate(timestamp[hora], "%Y-%m-%d %H:%M:%S")
		no2[hora] = row[, index, with = FALSE][[1]]
		validez[hora] = row[, index + 1, with = FALSE][[1]]

		index <- index + 2
	}

	return (data.frame(timestamp, date, no2, validez))
}

source("~/Desktop/r_scripts/datesFunctions.R")
pollutionDayDates2 <- function(row) {
	mes <- row[[7]]
	dia <- row[[8]]
	index <- 9
	timestamp <- numeric(24)
	date <- numeric(24)
	no2 <- character(24)
	validez <- character(24)
	for(hora in 1:24) {
		timestamp[hora] = as.numeric(ISOdate(2018, mes, dia, hora))
		date[hora] <- timestampToDate(timestamp[hora], "%Y-%m-%d %H:%M:%S")
		no2[hora] = row[[index]]
		validez[hora] = row[[index + 1]]

		index <- index + 2
	}

	return (data.frame(timestamp, date, no2, validez))
}

pollutionDayDates3 <- function(row) {
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

	return (data.frame(timestamp, date, pollutant, validez))
}

