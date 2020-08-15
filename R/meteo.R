# require(data.table)
# library(tidyr)

# pardo.2018 <- fread("~/Desktop/auto_meteo_python_cache/pardo/all.csv", showProgress=T)
# head(pardo.2018 %>% spread(key=shortName, value=value))
# as.Date("20180101", "%Y%m%d") + 1

tp.normalized <- function(frame){
	frame.len <- nrow(frame)
	dataDates <- numeric(frame.len)
	dataTimes <- numeric(frame.len)
	names <- character(frame.len)
	for(i in 1:nrow(frame)){
		step <- frame$step[i]
		time <- frame$dataTime[i]
		date <- frame$dataDate[i]
		name <- frame$shortName[i]
		if(time == 600 && name == "tp"){
			dataTimes[i] = step * 100
			dataDates[i] = date
		} else if(time == 1800 && step == 12 && name == "tp") {
			dataTimes[i] = 0
			dataDates[i] = format(as.Date(toString(date), "%Y%m%d") + 1, "%Y%m%d")		
		} else if(time == 1800 && name == "tp") {
			dataTimes[i] = (step + 12) * 100
			dataDates[i] = date
		} else {
			dataDates[i] = date
			dataTimes[i] = time
		}
	}
	result <- frame
	result$date <- dataDates
	result$dataTime <- dataTimes
	result$step <- NULL
	return(result)
}

## Calculate relative humidity from dew point. Source: http://bmcnoldy.rsmas.miami.edu/Humidity.html
hr <- function(data) {
	c <- 243.04
	b <- 17.625
	t <- (data$"2t" - 273.15)
	td <- (data$"2d" - 273.15)
	hr <- 100 * exp((c * b * (td - t)) / ((c + t) * (c + td)))
	data$hr <- hr
	data$"2d" <- NULL
	return(data)
}

## Transform temperature in kelvins to celsius degrees
tk2tc <- function(data) {
	data$"2t" <- (data$"2t" - 273.15)
	return(data)
}


uv2ds <- function(data) {
	u <- data$"10u"
	v <- data$"10v"
	if(is.na(u) || is.na(v)) {
		return (NA)
	} else {
		u <- unlist(u)
		v <- unlist(v)
		# Getting direction

		dirinrad <- atan2(u, v)
		dirindeg <- (dirinrad * 180) / pi
		dirindeg[dirindeg < 0] <- dirindeg[dirindeg < 0] + 360
		# Getting speed
		speed <- sqrt((u * u) + (v * v))
	}
	data$winddir <- dirindeg
	data$windspeed <- speed
	data$"10u" <- NULL
	data$"10v" <- NULL	
	return(data)
}

# Surface pressure from Pa to milibar
sp2mb <- function(data) {
	data$sp <- data$sp / 100
	return(data)

}

date <- function(data) {
	date <- data$dataDate
	time <- sprintf("%04d", data$dataTime) #Normalization to "DDDD" format
	dateformat <- "%Y%m%d%H%M"
	datetimestring <- paste(date, time)
	data$date <- as.POSIXct(datetimestring, dateformat, tz="UTC")
	data$dataTime <- NULL
	data$dataDate <- NULL
	return(data)
}



