require 'csv'
require 'json'
require 'open-uri'

# FavoriteCity.destroy_all
# City.destroy_all
# User.destroy_all

##seeds generation upon CSV files
# cities = City.all
# cities.each do |city|
#  city.house_marketprice = 0
#  city.save
# end


puts "Population seeds incoming..."
csv_options = { col_sep: ',', quote_char: '"', headers: :first_row }
filepath    = 'db/fixtures/population.csv'

@geocode_population = []
@city_name_population = []

# Pour chaque ligne du fichier
@geocode_population = []
CSV.foreach(filepath, csv_options) do |row|
  # je prends le geocode
  geocode = row['geocode']
  @geocode_population << geocode
  commune = row['city_name']
  @city_name_population << commune.upcase

  department_code = [22, 29, 35, 56]

  # # je regarde s'il commence par 22, 29, 35, 56
  next unless department_code.include?(geocode[0..1].to_i)

  # Je retrouve la ville en DB avec le meme nom
  # Si il n'y en a pas, je crée une nouvelle ville avec ce nom
  city = City.find_or_initialize_by(geocode: geocode)
  # je mets à jour ma ville en db avec la population du csv
  city.update(name: row['city_name'], population: row['population_2017'])
  # je sauve
  city.save!
end


puts "Train stations seeds incoming..."
## Nota1: These seeds are based on .json file from SNCF train french company.
## The files contains only train stations accessible by TRAINS for TRAVELERS.
## Train stations desserted by "TER-buses" or trains carrying only goods are not in the files and will not be in the db

## Nota2: Some big cities have more than one train station in the .json file --> i.e Toulouse city.
## --> The db will be updated as soon as one train station is found

filepath = 'db/fixtures/referentiel-gares-voyageurs.json'
serialized_train_stations = File.read(filepath)
train_stations = JSON.parse(serialized_train_stations)

@updated = 0

train_stations.each do |train_station|
  city_to_update = false
  @geocodes = []

  department = train_station["fields"]["departement_numero"]
  city_code = train_station["fields"]["commune_code"]
  train_station_name = train_station["fields"]["gare_alias_libelle_fronton"]

  # setup the geocode
  if (department == "2A" || department == "2B")
    geocode = department + "%03d" % city_code.to_i
    # puts "geocode: #{geocode}"
  else
    geocode = department.to_i.to_s + "%03d" % city_code.to_i
    # puts "geocode: #{geocode}"
  end
  @geocodes << geocode

  # update the db
  city_to_update = City.find_by("geocode": geocode)
  if city_to_update
    city_to_update.update("train_station": true)
    city_to_update.save!
    # puts "#{city_to_update.name} updated"
    # puts ""
    @updated += 1
  end
end

##detect haw many cities have more than one train station
# double_values = 0
# @geocodes.each do |geocode|
#   double_values += 1 if @geocodes.count(geocode) > 1
# end
## puts "#{@updated} db updates"
## puts "#{double_values} cities with more than 1 station"




puts "Latitude & Longitude seeds incoming..."
csv_options = { col_sep: ',', quote_char: '"', headers: :first_row }
filepath = 'db/fixtures/communes-coords-gps.csv'
CSV.foreach(filepath, csv_options) do |row|
  geocode = row['geocode']
  department_code = [22, 29, 35, 56]
  next unless department_code.include?(geocode[0..1].to_i) && @geocode_population.include?(geocode)
  city = City.find_or_initialize_by(geocode: geocode)
  city.update(name: row['city_name'], latitude: row['latitude'], longitude: row['longitude'])
  city.save!
end



puts "Network seeds incoming..."
csv_options = { col_sep: ',', quote_char: '"', headers: :first_row }
filepath = 'db/fixtures/couverture-4G.csv'
CSV.foreach(filepath, csv_options) do |row|
  geocode = row['geocode']
  department_code = [22, 29, 35, 56]
  next unless department_code.include?(geocode[0..1].to_i) && @geocode_population.include?(geocode)
  city = City.find_or_initialize_by(geocode: geocode)
  city.update(name: row['city_name'], network: row['4G_rate'])
  city.save!
end


puts "Fibre seeds incoming..."
csv_options = { col_sep: ',', quote_char: '"', headers: :first_row }
filepath = 'db/fixtures/couverture-fibre.csv'
CSV.foreach(filepath, csv_options) do |row|
  geocode = row['geocode']
  department_code = [22, 29, 35, 56]
  next unless department_code.include?(geocode[0..1].to_i) && @geocode_population.include?(geocode)
  city = City.find_or_initialize_by(geocode: geocode)
  city.update(name: row['city_name'], fibre: row['fibre_rate'])
  city.save!
end


puts "Medical services seeds incoming..."
# Ouvrir le fichier service-medicaux.csv
csv_options = { col_sep: ',', quote_char: '"', headers: :first_row }
filepath    = 'db/fixtures/service-medicaux.csv'

# Pour chaque ligne du fichier
CSV.foreach(filepath, csv_options) do |row|
  # je prends le geocode
  geocode = row['geocode']
  department_code = [22, 29, 35, 56]
  # # je regarde s'il commence par 22, 29, 35, 56
  next unless (department_code.include?(geocode[0..1].to_i) && @geocode_population.include?(geocode))

  # Je retrouve la ville en DB avec le meme nom
  # Si il n'y en a pas, je crée une nouvelle ville avec ce nom
  city = City.find_or_initialize_by(geocode: geocode)
  # je mets à jour ma ville en db avec la population du csv
  doctor = false
  city_doctor = row['doctor'].to_i
  doctor = true if city_doctor > 0
  city.update(name: row['city_name'], doctor: doctor)
  # je sauve
  city.save!
end


puts "Population average age seeds incoming..."
# Ouvrir le fichier Age-moyen-population.csv
csv_options = { col_sep: ';', quote_char: '"', headers: :first_row }
filepath    = 'db/fixtures/Age-moyen-population.csv'

# Pour chaque ligne du fichier
CSV.foreach(filepath, csv_options) do |row|
  # je prends le geocode
  geocode = row['geocode']
  department_code = [22, 29, 35, 56]

  # je regarde s'il commence par 22, 29, 35, 56
  next unless (department_code.include?(geocode[0..1].to_i) && @geocode_population.include?(geocode))

  # Je retrouve la ville en DB avec le meme nom
  # Si il n'y en a pas, je crée une nouvelle ville avec ce nom
  city = City.find_or_initialize_by(geocode: geocode)
  # je mets à jour ma ville en db avec la population du csv
  city.update(age_average: row['average_age_population'].to_i)
  # je sauve
  city.save!
end



puts "Commodities seeds incoming..."
# Ouvrir le fichier commerces.csv
csv_options = { col_sep: ',', quote_char: '"', headers: :first_row }
filepath    = 'db/fixtures/commerces.csv'

# Pour chaque ligne du fichier
CSV.foreach(filepath, csv_options) do |row|
  # je prends le geocode
  geocode = row['geocode']
  department_code = [22, 29, 35, 56]
  # # je regarde s'il commence par 22, 29, 35, 56

  next unless (department_code.include?(geocode[0..1].to_i) && @geocode_population.include?(geocode))

  # Je retrouve la ville en DB avec le meme nom
  # Si il n'y en a pas, je crée une nouvelle ville avec ce nom
  city = City.find_or_initialize_by(geocode: geocode)

#   # je compte le nombre de commerces
#   commodity_count = 0
#   supermarket = false

#   commodity_count = row['handiwork'].to_i + row['grocery'].to_i + row['bakery'].to_i\
#                     + row['butchery'].to_i + row['frozen'].to_i + row['fish_market'].to_i\
#                     + row['bookstore'].to_i + row['clothe'].to_i + row['appliance'].to_i\
#                     + row['shoestore'].to_i + row['it'].to_i + row['furniture'].to_i\
#                     + row['sport'].to_i + row['house'].to_i + row['hardware'].to_i\
#                     + row['cosmetic'].to_i + row['jewellery'].to_i + row['plant'].to_i\
#                     + row['optic'].to_i + row['medical_store'].to_i


  supermarket_count = row['supermarket'].to_i + row['hypermarket'].to_i + row['store'].to_i
  supermarket = (true if supermarket_count > 0) || false
  grocery = (true if row['grocery'].to_i > 0) || false
  handiwork = (true if row['handiwork'].to_i > 0) || false
  bakery = (true if row['bakery'].to_i > 0) || false
  butchery = (true if row['butchery'].to_i > 0) || false
  fish_market = (true if row['fish_market'].to_i > 0) || false
  bookstore = (true if row['bookstore'].to_i > 0) || false
  clothe = (true if row['clothe'].to_i > 0) || false
  shoestore = (true if row['shoestore'].to_i > 0) || false
  it = (true if row['it'].to_i > 0) || false
  furniture = (true if row['furniture'].to_i > 0) || false
  sport = (true if row['sport'].to_i > 0) || false
  hardware = (true if row['hardware'].to_i > 0) || false
  cosmetic = (true if row['cosmetic'].to_i > 0) || false
  jewellery = (true if row['jewellery'].to_i > 0) || false
  plant = (true if row['plant'].to_i > 0) || false
  optic = (true if row['optic'].to_i > 0) || false
  medical_store = (true if row['medical_store'].to_i > 0) || false
  gas_station = (true if row['gas_station'].to_i > 0) || false

  city.update(name: row['city_name'], grocery: grocery, supermarket: supermarket, handiwork: handiwork,
              bakery: bakery, butchery: butchery, fish_market: fish_market, bookstore: bookstore, clothe: clothe,
              shoestore: shoestore, it: it, furniture: furniture, sport: sport, hardware: hardware,
              cosmetic: cosmetic, jewellery: jewellery, plant: plant, optic: optic, medical_store: medical_store,
              gas_station: gas_station )
#   # je sauve
  city.save!
end
#   # je mets à jour ma ville en db avec la population du csv




puts "Primary and secondary schools seeds incoming..."
csv_options = { col_sep: ';', quote_char: '"', headers: :first_row }
filepath    = 'db/fixtures/ecoles.csv'

# Pour chaque ligne du fichier
CSV.foreach(filepath, csv_options) do |row|

  geocode = row['geocode']
  department_code = [22, 29, 35, 56]
  next unless (department_code.include?(geocode[0..1].to_i) && @geocode_population.include?(geocode))
  city = City.find_or_initialize_by(geocode: geocode)
  city.update(name: row['city_name'])

  primary_school = (row['code_nature'] == "151" || row['code_nature'] == "101")
  city.update(primary_school: true) if primary_school

  secondary_school = (row['code_nature'] == "340" ||
                      row['code_nature'] == "300" ||
                      row['code_nature'] == "320" ||
                      row['code_nature'] == "302" ||
                      row['code_nature'] == "306" ||
                      row['code_nature'] == "315" ||
                      row['code_nature'] == "334" ||
                      row['code_nature'] == "390")
  city.update(secondary_school: true) if secondary_school

  city.save!
end




# p "Description and photos seeds incoming"
# cities = City.all
# cities.each do |city|
# # p city.population
#   url = URI.parse "https://fr.wikipedia.org/w/api.php?action=query&format=json&formatversion=2&redirects=true&prop=info%7Cextracts%7Cpageimages&exsentences=2&explaintext=true&piprop=thumbnail&pithumbsize=500&titles=#{URI.encode city.name}"
#   city_serialized = URI.open(url).read
#   city_infos = JSON.parse(city_serialized)
#   if city_infos['query']['pages'][0]['extract'].nil?
#     city.description = ""
#   else
#     city.description = city_infos['query']['pages'][0]['extract'].gsub(/\n+(==|===)\s\w.+/, "\n")
#   end

#   if city_infos['query']['pages'][0]['thumbnail'].nil?
#     city.photo = ""
#   else
#    city.photo = city_infos['query']['pages'][0]['thumbnail']['source']
#   end

#   city.save!

# end
