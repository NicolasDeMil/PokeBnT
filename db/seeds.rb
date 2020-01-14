require "open-uri"
require "nokogiri"
require "json"
require "faker"
require 'csv'
puts 'Cleaning database...'
Pokemon.destroy_all
User.destroy_all
UserPokemon.destroy_all
#Initializers
counter = 0
pokemon_all_moves = []
#Setting up CSV File
# csv_options = { col_sep: ',', force_quotes: true, quote_char: '"' }
# filepath    = 'pokemons.csv'
# CSV.open(filepath, 'wb', csv_options) do |csv|
#   csv << ['Name', 'HP', 'Kind Of', 'Picture','Number', 'Description', 'Speed', 'Special Defense', 'Special Attack', 'Defense', 'Attack', 'Moves', 'Weakness']
# end
puts 'Creating Pokemon...'
#Conditionals
until counter == 151
  counter += 1
  #Scraping Pokemon.com website
  url = "https://www.pokemon.com/uk/pokedex/#{counter}"
  html_file = open(url).read
  html_doc = Nokogiri::HTML(html_file)
  #Parse PokeAPI - Pokemon Info
  url = "https://pokeapi.co/api/v2/pokemon/#{counter}/"
  pokemon_serialized = open(url).read
  pokemon = JSON.parse(pokemon_serialized)
  #Pokemon Attributes
  pokemon_name = html_doc.search('.pokedex-pokemon-pagination-title').text.strip.split(' ')[0]
  pokemon_number = html_doc.search('.pokedex-pokemon-pagination-title').text.strip.split(' ')[1]
  pokemon_speed = pokemon['stats'][0]['base_stat']
  pokemon_special_defense = pokemon['stats'][1]['base_stat']
  pokemon_special_attack = pokemon['stats'][2]['base_stat']
  pokemon_defense = pokemon['stats'][3]['base_stat']
  pokemon_attack = pokemon['stats'][4]['base_stat']
  pokemon_hp = pokemon['stats'][5]['base_stat']
  pokemon_base_xp = pokemon['base_experience']
  pokemon_kind = html_doc.search('.dtm-type ul li a').first.text
  pokemon_weakness = html_doc.search('.dtm-weaknesses ul li a').first.text.strip
  pokemon_picture = html_doc.search('.profile-images img').attribute('src').value
  pokemon_description = html_doc.search('.version-descriptions.active .version-x').text.strip
  # Pokemon Moves
  pokemon_moves = pokemon["moves"].each do |move|
    pokemon_move_info = move.values_at("move")[0].values_at("name", "url")
    pokemon_move_learned_at = move.values_at("version_group_details")[0][0].values_at("level_learned_at")[0]
    pokemon_move_serialized = open(pokemon_move_info[1]).read
    pokemon_specific_move_info = JSON.parse(pokemon_move_serialized)
    if pokemon_specific_move_info['power'] != nil && pokemon_move_learned_at != 0
      pokemon_move_name = pokemon_move_info[0].gsub('-', ' ').capitalize
      pokemon_move_power = pokemon_specific_move_info['power']
      pokemon_move_accuracy = pokemon_specific_move_info['accuracy']
      pokemon_move_pp = pokemon_specific_move_info['pp']
      pokemon_move_type = pokemon_specific_move_info["type"]["name"]
      pokemon_move_damage_class = pokemon_specific_move_info['damage_class']["name"]
      pokemon_one_move = Hash.new
      pokemon_one_move["name"] = pokemon_move_name
      pokemon_one_move["power"] = pokemon_move_power
      pokemon_one_move["accuracy"] = pokemon_move_accuracy
      pokemon_one_move["pp"] = pokemon_move_pp
      pokemon_one_move["type"] = pokemon_move_type
      pokemon_one_move["learned_at"] = pokemon_move_learned_at
      pokemon_one_move["damage_class"] = pokemon_move_damage_class
    end

    pokemon_all_moves << pokemon_one_move if pokemon_one_move && pokemon_one_move["power"] != nil
  end
  #-----------------------
  #Populating the CSV File
  # CSV.open(filepath, 'wb', csv_options) do |csv|
  #   csv << ["#{pokemon_name}", "#{pokemon_hp}", "#{pokemon_kind}","#{pokemon_picture}","#{pokemon_number}", "#{pokemon_description}", "#{pokemon_speed}", "#{pokemon_special_defense}", "#{pokemon_special_attack}", "#{pokemon_defense}", "#{pokemon_attack}",   "#{pokemon_all_moves}", "#{pokemon_weakness}"]
  # end
  #Parsing CSV File
  # csv_options = { col_sep: ',', quote_char: '"', headers: :first_row }
  # filepath    = 'pokemons.csv'
  # CSV.foreach(filepath, csv_options) do |row|
  #   @pokemon = Pokemon.create! ({
  #   name: row['Name'],
  #   hp: row['HP'],
  #   kind_of: row['Kind Of'],
  #   picture: row['Picture'],
  #   number: row['Number'],
  #   description: row['Description'],
  #   speed: row['Speed'],
  #   special_defense: row['Special Defense'],
  #   special_attack: row['Special Attack'],
  #   defense: row['Defense'],
  #   attack: row['Attack'],
  #   moves: row['Moves'],
  #   weakness: row['Weakness'],
  # })
  # end
  #-----------------------
  #Creation of Pokemon Instances
  @pokemon = Pokemon.create! ({
    name: pokemon_name,
    hp: pokemon_hp,
    kind_of: pokemon_kind,
    picture: pokemon_picture,
    number: pokemon_number,
    description: pokemon_description,
    speed: pokemon_speed,
    special_defense: pokemon_special_defense,
    special_attack: pokemon_special_attack,
    defense: pokemon_defense,
    attack: pokemon_attack,
    weakness: pokemon_weakness,
    base_xp: pokemon_base_xp,
    moves: pokemon_all_moves,
  })
  puts "#{pokemon_name} has been created. #{counter} of 151 Pokemon created."
  #Creation of Pokemon Instances - old
# @pokemon = Pokemon.create! ({
#   name: pokemon_name,
#   number: pokemon_number,
#   description: pokemon_description,
#   speed: pokemon_speed,
#   special_defense: pokemon_special_defense,
#   special_attack: pokemon_special_attack,
#   defense: pokemon_defense,
#   attack: pokemon_attack,
#   hp: pokemon_hp,
#   kind_of: pokemon_kind,
#   attack_name: pokemon_attack_name,
#   attack_value: pokemon_attack_value,
#   picture: pokemon_picture
# })
end
puts "All #{counter} Pokemon Created"
puts 'Creating Users...'
10.times do
  @user = User.create! ({
    email: Faker::Internet.email,
    username: Faker::Internet.username,
    password: "123123",
    avatar: "https://loremflickr.com/400/400",
    battles_fought: rand(5..20),
    battles_won: 5,
  })
end
puts "All 10 Users have been created"
puts 'Assigning 3 pokemons to users...'
User.all.each do |user|
  3.times do
    UserPokemon.create! ({
      pokemon: Pokemon.all.sample,
      user: user
    })
  end
end
puts "Finished"
puts "Finished creating our database"