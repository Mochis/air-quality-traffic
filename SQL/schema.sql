-- MODEL
CREATE TABLE air_stations (
	id INT PRIMARY KEY,
	name VARCHAR(50),
	lat DECIMAL(17, 12),
	lon DECIMAL(17, 12),
	type VARCHAR(50),
	height INT,
	lat_grib DECIMAL(10,5),
	lon_grib DECIMAL(10,5)
);

CREATE TABLE traffic_stations (
	id INT PRIMARY KEY,
	lat DECIMAL(17, 12),
	lon DECIMAL(17, 12),
	type VARCHAR(50),
	district_code SMALLINT,
	elem_code VARCHAR(50),
	address VARCHAR(200)	
);

CREATE TABLE distance (
	air_id INT NOT NULL,
	traffic_id INT NOT NULL,
	FOREIGN KEY (air_id) REFERENCES air_stations (id) ON DELETE CASCADE,
	FOREIGN KEY (traffic_id) REFERENCES traffic_stations (id) ON DELETE CASCADE,
	PRIMARY KEY (air_id, traffic_id)
);