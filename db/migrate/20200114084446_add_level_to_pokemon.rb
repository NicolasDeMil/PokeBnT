class AddLevelToPokemon < ActiveRecord::Migration[5.2]
  def change
  	add_column :pokemons, :level, :integer
  end
end
