class GamesController < ApplicationController
  def new
    @game = Game.new
  end

  def create
    @game = current_user.simple_wods.create(simple_wod_params)
    if @game.valid?
      redirect_to game_path(@game)
    else
      flash[:alert] = "Error creating game!"
      render :new, :status => :unprocessable_entity
    end
  end

  def show
  rescue ActiveRecord::RecordNotFound 
      render :text => "404 Error - Game Not Found", :status => :not_found
  end

private
  helper_method :current_game
  def current_game
    @current_game ||= Game.find(params[:id])
  end

  def game_params
    params.require(:game).permit(:game_name)  
  end
end
