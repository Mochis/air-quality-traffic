# load geosphere
# load air stations
# load traffic stations
# for every air station
	# for every traffic station
		# calculate distance between 2 lat lon points and save
		# the result with id_air_station, id_traffic_station, distance
# order list ascending distance

library(geosphere)
pmedair <- read.csv("~/Desktop/stations", sep=";")
pmedtraffic <- read.csv("pmed_validos_2018.csv", sep=";")
size <- nrow(pmedair) * nrow(pmedtraffic) # Nº air stations x Nº traffic stations
air.id <- numeric(size) 
traffic.id <- numeric(size)
distance <- numeric(size)
m <- 1
for(i in 1:nrow(pmedair)) {
	air_id <- pmedair$id_station[i]
	air_lat <- pmedair$lat_station[i]
	air_lon <- pmedair$lon_station[i]
	for(j in 1:nrow(pmedtraffic)) {
		traffic_id <- pmedtraffic$id_pmed_traffic[j]
		traffic_lat <- pmedtraffic$lat_pmed_traffic[j]
		traffic_lon <- pmedtraffic$lon_pmed_traffic[j]
		dist <- distVincentyEllipsoid(c(air_lat, air_lon), c(traffic_lat, traffic_lon))
		air.id[m] = air_id
		traffic.id[m] = traffic_id
		distance[m] = dist
		m <- m + 1
	}
}

air.traffic.distances <- data.frame(air.id, traffic.id, distance)
air.traffic.distances <- air.traffic.distances[with(air.traffic.distances, order(air.id, distance)), ]
write.csv(air.traffic.distances, "distances.csv", row.names=FALSE, quote=FALSE)