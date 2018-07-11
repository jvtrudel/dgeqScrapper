require 'json'
require 'fileutils'

# Prend un fichier geojson contenant un 'FeatureCollection' et produit un fichier pour chaque propriété désignée
#
# EXEMPLE:
#    splitGeojsonByProperties.rb mydata.geojson my_properties outputfile


=begin
# bonne idée de mettre ça sous forme de classe?
class geojson

   def initialize()
      @metadata={}
      @features=[]
   end

   def add_metadata(name,value)
      # ajoute une metadata
   end

   def add_feature(feature)
      # ajoute une feature
   end

   def print(path)
      # imprime
   end
end
=end


# À la mitaine avec les données de 2014
# TODO: utiliser des arguments en entré

# variables
target_property="NM_TRI_CEP";


# Importation des données
file=File.read('build/tmp/secteurs2014.geojson');
source=JSON.parse(file);

# On récupère des méta-données pertinentes
metadata={}
metadata["crs"]=source["crs"]

data={}


# Boucle sur les features

source['features'].each do | feature |
   # todo: mettre ça dans un try/catch

   # si existe pas, crée un array
   unless data.key?(feature['properties'][target_property])
      #puts feature['properties'][target_property]
      data[feature['properties'][target_property]]=[]
   end
   data[feature['properties'][target_property]].push(feature)
end

# Écrit le tout dans un fichier
data.each do |key,value|
   # On s'assure que le repertoire existe
   filename='build/tmp/'+key+'/data.geojson'
   dirname = File.dirname(filename)
   unless File.directory?(dirname)
     FileUtils.mkdir_p(dirname)
   end
   out_json={"type"=>"FeatureCollection","name"=>key,"crs"=>metadata["crs"],"features"=>value}
   File.open(filename, 'w') do |f|
      f.puts out_json.to_json
   end
end
