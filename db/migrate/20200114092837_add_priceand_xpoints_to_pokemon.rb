class AddPriceandXpointsToPokemon < ActiveRecord::Migration[5.2]
  def change
    add_column :pokemons, :price, :integer
    add_column :pokemons, :xpoints, :integer
  end
end
