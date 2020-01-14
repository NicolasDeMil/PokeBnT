class PokemonsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index, :show]
  def index
    if params[:query].present?
      @pokemons = policy_scope(Pokemon).global_search(params[:query])
    else
      @pokemons = policy_scope(Pokemon).paginate(page: params[:page]).per_page(20)
    end
    authorize @pokemons
  end

  def show
    @pokemon = Pokemon.find(params[:id])
    authorize @pokemon

    @moves = @pokemon.moves.sort_by { |move| move["learned_at"] }
  end
end
