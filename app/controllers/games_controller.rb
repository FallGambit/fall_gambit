class GamesController < ApplicationController
  before_action :authenticate_user!, only: [:create, :update]

  def new
    @game = Game.new
  end

  def create
    # don't necessarily have to do it this way, but will record game creator
    @game = current_user.games.create(game_create_params)
    if @game.valid?
      redirect_to game_path(@game)
    else
      flash.now[:alert] = "Error creating game!"
      render :new, :status => :unprocessable_entity
    end
  end

  def show
    @game = Game.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render :text => "404 Error - Game Not Found", :status => :not_found
  end

  def update
    @game = Game.find(params[:id])
    if @game.white_user_id.nil?
      if current_user.id != @game.black_user_id
        @game.update_attributes(white_user_id: current_user.id)
        redirect_to game_path(@game)
      else
        flash[:alert] = "Cannot join your own game!"
        redirect_to root_path
      end
    elsif @game.black_user_id.nil?
      if current_user.id != @game.white_user_id
        @game.update_attributes(black_user_id: current_user.id)
        redirect_to game_path(@game)
      else
        flash[:alert] = "Cannot join your own game!"
        redirect_to root_path
      end
    else
      flash[:alert] = "Game already filled!"
      redirect_to root_path
    end

  end

  private

  helper_method :current_game
  def current_game
    @current_game ||= Game.find(params[:id])
  end

  def game_create_params
    if params[:game][:creator_plays_as_black] == '1'
      params.require(:game).permit(:game_name, :creator_plays_as_black).merge(black_user_id: current_user.id)
    else
      params.require(:game).permit(:game_name, :creator_plays_as_black).merge(white_user_id: current_user.id)
    end
    
  end
end
