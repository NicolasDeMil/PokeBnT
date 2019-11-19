require "open-uri"
require "nokogiri"
require "json"
require "faker"

puts 'Cleaning database...'
Pokemon.destroy_all
User.destroy_all

puts 'Creating Pokemon...'

counter = 0
until counter == 151

#Scraping Pokemon.com website
counter += 1
url = "https://www.pokemon.com/uk/pokedex/#{counter}"
html_file = open(url).read
html_doc = Nokogiri::HTML(html_file)

#Parse PokeAPI - Pokemon Info
url = "https://pokeapi.co/api/v2/pokemon/#{counter}/"
pokemon_serialized = open(url).read
pokemon = JSON.parse(pokemon_serialized)

#Parse PokeAPI - Attack Move Info
moves_info_url = pokemon['moves'][0]['move']['url']
moves_serialized = open(moves_info_url).read
moves = JSON.parse(moves_serialized)

#Pokemon Attributes
pokemon_name = html_doc.search('.pokedex-pokemon-pagination-title').text.strip.split(' ')[0]

pokemon_number = html_doc.search('.pokedex-pokemon-pagination-title').text.strip.split(' ')[1]

pokemon_hp = pokemon['stats'][-1]['base_stat']

pokemon_kind = html_doc.search('.dtm-type ul li a').first.text

pokemon_attack_name = pokemon['moves'][0]['move']['name'].capitalize

pokemon_attack_value = moves['power']

pokemon_picture = html_doc.search('.profile-images img').attribute('src').value

pokemon_region = "Kanto"


#Creation of Pokemon Instances
@pokemon = Pokemon.create! ({
  name: pokemon_name,
  number: pokemon_number,
  hp: pokemon_hp,
  kind_of: pokemon_kind,
  attack_name: pokemon_attack_name,
  attack_value: pokemon_attack_value,
  region: pokemon_region,
  picture: pokemon_picture
})

end

puts "All #{counter} Pokemon Created"

puts 'Creating Users...'


10.times do
  @user = User.create! ({
    email: Faker::Internet.email,
    username: Faker::Internet.username,
    password: "123123",
    pokeball: rand(1..10),
    energy: rand(1..5)
  })
end

puts "All 10 Users have been created"

puts "Finished creating our database"
