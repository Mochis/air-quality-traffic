# Get unix timestamps
startTimestamp = as.numeric(as.POSIXct("2018-01-01 00:00:00", tz = "UTC"))
endTimestamp = as.numeric(as.POSIXct("2019-01-01 00:00:00", tz = "UTC"))
increment = 900 # 15 minutes == 900 seconds
currentTimestamp = startTimestamp

timestamp = c()
date = c()

while(currentTimestamp <= endTimestamp) {
	timestamp = append(timestamp, currentTimestamp)
	currentDate = as.POSIXct(currentTimestamp, origin="1970-01-01 00:00:00", tz = "UTC", format = "%Y-%m-%d %H:%M:%S")
	date = append(date, currentDate)
	currentTimestamp = currentTimestamp + increment
}

attributes(date)$tzone = "UTC"
timestampAndDate2018 = data.frame(timestamp = timestamp, date = date)
