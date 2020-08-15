dateToTimestampUTC <- function(date, dateFormat) {
	return (as.numeric(as.POSIXct(date, format=dateFormat, tz="UTC")))
}

timestampToDate <- function(timestamp, formatToSet) {
	date <- as.POSIXct(timestamp, origin="1970-01-01", tz = "UTC")
	return (format(date, formatToSet))
}