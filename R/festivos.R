
# load festivos from file
festivos.generate <- function() {
	library(data.table)

	festivos <- fread("~/Desktop/data_by_station/festivos.csv", sep=",")
	fmt <- "%Y-%m-%d %H"
	dates.hour <- seq(as.POSIXct("2018-01-01 00:00:00", format=fmt), as.POSIXct("2019-07-01 00:00:00", format=fmt), by=3600)
	festivos.hourly <- data.frame(date=dates.hour)
	festivos.hourly$festivo.number <- lapply(festivos.hourly$date, function(x) festivos[format(festivos$date) == format(x, "%Y-%m-%d"),]$festivo.number)
	festivos.hourly <- head(festivos.hourly, -1) # delete last line
	festivos.hourly$festivo.number <- unlist(festivos.hourly$festivo.number)
	output.filename <- paste("~/Desktop/data_by_station/", "festivos_hourly.csv", sep="")
	write.csv(festivos.hourly, output.filename, row.names=FALSE, quote=FALSE)
}