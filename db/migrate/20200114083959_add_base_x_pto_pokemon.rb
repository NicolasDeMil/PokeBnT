class AddBaseXPtoPokemon < ActiveRecord::Migration[5.2]
  def change
  	add_column :pokemons, :base_xp, :integer
  end
end
