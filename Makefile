#shapefile2014:
	# y'a un fuck avec
	#wget https://www.electionsquebec.qc.ca/documents/zip/sections%20de-vote-elections-2014-shapefile.zip -O data/shapefile2014.zip
	#unzip data/shapefile2014.zip data/shapefile2014


#shapefile2012:
	#wget https://www.electionsquebec.qc.ca/documents/zip/sections-de-vote-elections-2012-shapefile.zip -O data/shapefile2012.zip
	#unzip data/shapefile2012.zip data/shapefile2012

resultats2014:
	# récupération des sections de vote
	#
	#récupération des résultats de vote
	wget https://www.electionsquebec.qc.ca/documents/zip/resultats-section-vote/2014-04-07.zip -O data/resultats2014.zip
	uzip data/resultats2014.zip data/resultats2014
	# traitement des données
	#récupération des résultats de vote
	./bin/resultatsCsv2Json.rb data/RIMOUSKI/resultats2014-rimouski.csv data/RIMOUSKI/resultats2014.js

geojson2012:
	mkdir -p build/tmp
	./bin/shapefile2geojson $(pwd)/Sections\ de\ vote\ C\314\247lections\ 2012-shapefile Sections\ de\ Vote\ Elections\ 2012_09_04 EPSG:900913 build/tmp secteurs2012

geojson2014:
	mkdir -p build/tmp
	./bin/shapefile2geojson data/Sections-de-vote-Elections-2014-shapefile Sections-de-Vote-Elections-2014_04_07 crs:84 build/tmp secteurs2014

splitCirconscription2014:
	ruby bin/splitGeojsonByProperties.rb



site:
	./bin/build_site RIMOUSKI
