library(data.table)
library(fasttime)

readfile.traffic <- function(month, anio) {
	filename <- paste(month, "-", anio, ".csv", sep="")
	data <- fread(filename, sep=";") # Needed data.table library for using fread function
	return(data)
}

process.traffic <- function(month, pmed, dates, anio) {
	traffic <- readfile.traffic(month, anio)
	# traffic19 <- readfile.traffic(month, 2019)
	# Filter data on valid meditions points
	traffic <- traffic[id %in% pmed$id_pmed_traffic]
	traffic <- traffic[fastPOSIXct(fecha) %in% dates] # Fast implementation of POSIXct.
	# Dropping unused columns
	traffic$tipo_elem <- NULL
	traffic$ocupacion <- NULL
	traffic$carga <- NULL
	traffic$vmed <- NULL
	traffic$error <- NULL
	traffic$periodo_integracion <- NULL
	traffic$date <- traffic$fecha # Changing column name
	traffic$fecha <- NULL
	# Changing ther order of columns
	traffic <- setcolorder(traffic, c("date", "id", "intensidad"))
	# Reordering data on "fecha" column
	traffic <- traffic[with(traffic, order(fastPOSIXct(date))), ]
	output.filename <- paste(anio, "_", month, "_traffic", sep="")
	write.csv(traffic, output.filename, row.names=FALSE, quote=FALSE)
	print(paste("Escrito", output.filename, ". Nº elem:", nrow(traffic)))
	rm(traffic) # clear memory
}

# Load valid medition points
pmed <- read.csv("pmed_traffic_validos", sep=";")
fmt <- "%Y-%m-%d %H:%M:%S"
dates <- seq(as.POSIXct("2018-01-01 00:00:00", format=fmt), 
	as.POSIXct("2019-07-01 00:00:00", format=fmt), by=3600)
# Traffic month data processing
for(i in seq(1:12)) {
	process.traffic(sprintf("%02d", i), pmed, dates, 2018)
}

# Traffic month 2019
for(i in seq(1:6)) {
	process.traffic(sprintf("%02d", i), pmed, dates, 2019)
}
