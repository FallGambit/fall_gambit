class GamesController < ApplicationController
  before_action :authenticate_user!, only: [:create, :update]

  def new
    @game = Game.new
  end

  def create
    @game = Game.create(game_create_params)
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
    if @game.white_user_id.nil? || @game.black_user_id.nil?
      update_player
      redirect_to game_path(@game)
    else
      @game.errors.add(:base, "Game is full!")
      handle_update_errors
    end
  end

  private

  helper_method :current_game
  def current_game
    @current_game ||= Game.find(params[:id])
  end

  def merge_player_color_choice_param
    if params[:game][:creator_plays_as_black] == '1'
      { black_user_id: current_user.id }
    else
      { white_user_id: current_user.id }
    end
  end

  def game_create_params
    params.require(:game).permit(:game_name, :creator_plays_as_black,
                                 :white_user_id, :black_user_id)
      .merge(merge_player_color_choice_param)
  end

  def update_player
    if @game.white_user_id.nil?
      @game.update_attributes(white_user_id: current_user.id)
      @game.set_white_player_id
    else
      @game.update_attributes(black_user_id: current_user.id)
      @game.set_black_player_id
    end
  end

  def handle_update_errors
    return unless @game.errors.present?
    flash[:alert] = @game.errors.full_messages.first
    redirect_to root_path
  end
end
