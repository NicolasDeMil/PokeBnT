class UserPokemonsController < ApplicationController
  def new
    @user_pokemon = UserPokemon.new
    authorize @user_pokemon
  end

  def create
    @user_pokemon = UserPokemon.new(user_pokemon_params)

    authorize @user_pokemon

    @user_pokemon.user = current_user
    if @user_pokemon.save
      redirect_to user_path(current_user)
    else
      render :new
    end
  end

  def destroy
    @user_pokemon = UserPokemon.find(params[:id])

    authorize @user_pokemon

    if @user_pokemon.delete
      redirect_to user_path(current_user)
    else
      render :new
    end
  end

  private

  def user_pokemon_params
    # *Strong params*: You need to *whitelist* what can be updated by the user
    # Never trust user data!
    params.require(:user_pokemon).permit(:user_id, :pokemon_id)
  end
end
