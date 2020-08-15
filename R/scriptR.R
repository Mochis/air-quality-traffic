library(dplyr)
sumaDos <- function(num1, num2) {
	return (num1 + num2)
}

intensidades <- function(ids) {
	print(xx)
	return (xx[[ids]] <- sum(filter(datint, id==ids) %>% select("intensidad")))
}

intensidades2 <- function(ids) {
	res <- c()
	for(i in ids) {
		res <- c(res, sum(filter(datint, id==i) %>% select("intensidad")))
	}
	return (res)
}

intensidades3 <- function(ids) {
	return (sum(filter(datint, id==ids) %>% select("intensidad")))
}

intensidadesTotal <- function(ordered) {
	last = 0
	res <- list()
	for(numrow in 1:nrow(ordered)) {
		id <- ordered[numrow, "id"]
		intensidad <- ordered[numrow, "intensidad"]
		if(last != id) {
			last = id
			res[[id]] = intensidad
		} else {
			res[[id]] = res[[id]] + intensidad 
		}
	}
	return (res)
}

intensidadesTotalPreAllo <- function(ordered) {
	last = 0
	res <- numeric(nrow(ordered))
	for(numrow in 1:nrow(ordered)) {
		#id <- ordered[numrow, "id"]
		intensidad <- ordered[numrow, "intensidad"]
		#res[id] <- res[id] + intensidad
		res[1001] <- res[1001] 
	}
	return (res)
}

intensidadesTotalParallel <- function(ids) {
	
}

isValidId <- function(id, validIdsList) {
	return (length(which(validIdsList == id)) > 0)
}
