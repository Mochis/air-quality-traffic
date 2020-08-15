from bs4 import BeautifulSoup
import requests
import time


def estaciones():
	return {
		4:'Plaza España', 
		8:'Escuelas Aguirre', 
		16:'Arturo Soria', 
		18:'Farolillo', 
		24:'Casa de Campo', 
		35:'Plaza del Carmen', 
		36:'Moratalaz', 
		38:'Cuatro Caminos', 
		39:'Barrio del Pilar', 
		54:'Ensanche de Vallecas', 
		56:'Plaza Elíptica', 
		58:'El Pardo', 
		59:'Juan Carlos I', 
		102:'J.M. de Moratalaz', 
		103:'J.M. de Villaverde', 
		104:'E.D.A.R. la China', 
		106:'C.M.. Acustica', 
		107:'J.M. Hortaleza', 
		108:'Peñagrande', 
		109:'J.M. Chamberi', 
		110:'J.M. Centro', 
		111:'J.M. Chamartin', 
		112:'Vallecas 1', 
		113:'Vallecas 2', 
		114:'Matadero 1', 
		115:'Matadero 2'
	}

station = 4
day = 1
month = 1
year = 2013
date = str(day) + '/' + str(month) + '/' + str(year)
magnitud = ''

payload = {
	'menu': 'consulta',
	'smenu': 'reports',
	'link': 'meteorology',
	'view': 'data',
	'magnitud': magnitud,
	'estacion': station,
	'date': date
}

for year in range(2013, 2018 + 1):
	for month in range(1, 12 + 1):
		for station in estaciones().keys():
			payload['estacion'] = station
			with open(str(year) + str(month) + '_station_' + str(station), 'a+') as file:
				for day in range(1, 31 + 1):
					date = str(day) + '/' + str(month) + '/' + str(year)
					payload['date'] = date

					#start_page = time.time()
					response = requests.post(
						"http://www.mambiente.madrid.es/sica/scripts/index.php?lang=es",
						data = payload
					)

					soup = BeautifulSoup(response.content, 'html.parser')
					#end_page = time.time()
					#print('Tiempo pagina: ' + str(end_page - start_page))

					#start_processing = time.time()
					if day == 1:
						infoStation = soup.find_all('td', class_ = 'hs')
						if len(infoStation) == 0:
							file.close()
							break
						for column in infoStation:
							file.write(column.get_text())
							file.write(';')
						file.write('\n')
						header = soup.find_all('td', class_ = 'hd')
						for column in header:
							file.write(column.get_text())
							file.write(';')
						file.write('Station;')
						file.write('Date;')
						file.write('\n')
					count = 1
					for column in soup.find_all('td', class_ = 'datos'):
						file.write(column.get_text())
						file.write(';')
						if count == len(header):
							file.write(str(station) + ';')
							file.write(str(date) + ';')
							file.write('\n')
							count = 1
						else:
							count = count + 1
					#end_processing = time.time()
					#print('Tiempo procesamiento un dia: ' + str(end_processing - start_processing))
			file.close()