class PiecesController < ApplicationController
  before_action :authenticate_user!
  before_action :game_must_not_be_over, :must_be_users_turn, :must_be_users_piece
  after_action :flash_notice, only: :update

  def show
    @piece = Piece.find(params[:id])
    @current_game = current_game
    if @piece.game.player_missing?
      flash[:alert] = "Cannot move until both players have joined!"
      redirect_to game_path(@piece.game) and return
    end
  end

  def update
    if @piece.game.player_missing?
      flash[:alert] = "Cannot move until both players have joined!"
      redirect_to game_path(@piece.game) and return
    end
    @piece = Piece.find(params[:id])
    @old_x = @piece.x_position
    @old_y = @piece.y_position
    new_x = params[:x].to_i
    new_y = params[:y].to_i
    if @piece.move_to!(new_x, new_y)
      opponent_king = @piece.game.kings.where.not(color: @piece.color).first
      if @piece.game.checkmate?(opponent_king) # current player placed other player in checkmate - wins!
        @piece.game.update_attributes(game_winner: @piece.user_id) # set game winner
        flash[:notice] = "Checkmate! You win!" # will only get set and display on winner's turn
      elsif @piece.piece_type == "Pawn" && @piece.promote? # pawn can be promoted
        redirect_to promotion_choice_piece_path(@piece) and return 
      else
        # check for stalemate of other player after move and set game model field
        if @piece.game.stalemate?(opponent_king)
          @piece.game.user_turn == @piece.game.white_user_id ? other_player = "Black" : other_player = "White"
          flash[:notice] = other_player + " is in stalemate! Game is a draw."
        else
          @piece.game.determine_check(opponent_king) # set check field in game model
        end
      end
      # end turn
      @piece.game.finish_turn(@piece.user) # otherwise turn goes to other player
    end
    redirect_to game_path(@piece.game)
    begin
      PrivatePub.publish_to("/games/#{@piece.game.id}", "window.location.reload();")
    rescue Errno::ECONNREFUSED
      # flash.now[:alert] = "Pushing to Faye Failed"
      return
    end
  end

  def promotion_choiceup
    @piece = Piece.find(params[:id])
    # need to loop through these to check for stalemate once that branch is merged 
    @promotion_list = %w(Queen Knight Rook Bishop)
    @promotion_list.each do |promo|
      @piece.promote!(promo)
      @piece = Piece.find(params[:id]) #reload new type
      if !@piece.game.stalemate?(@piece.game.kings.where.not(color: @piece.color).first)
        # button list is what gets passed to the user input form
        @button_list << [promo, promo] # add piece to possible promotion type if it doesn't cause a stalemate
      end
    end
    @piece.udpate(piece_type: "Pawn")
    @piece.save!
    @piece = Piece.find(params[:id]) # reload original pawn type
    binding.pry
    # passed to user input form
    #@button_list = [['Queen', 'Queen'],['Knight', 'Knight'],['Rook', 'Rook'],['Bishop', 'Bishop']]
  end

  def promote_pawn
    type_update = pawn_update_params[:piece_type] # grab from params
    if @piece.promote!(type_update)
      @piece = Piece.find(params[:id]) #reload as new piece type
      # check for checkmate, stalemate/check, advance turn
      # a lot of this is pulled from move_to!, but we have to check again with the new piece type
      opponent_king = @piece.game.kings.where.not(color: @piece.color).first
      if @piece.game.checkmate?(opponent_king) # current player placed other player in checkmate - wins!
        @piece.game.update_attributes(game_winner: @piece.user_id) # set game winner
        flash[:notice] = "Checkmate! You win!" # will only get set and display on winner's turn
      elsif @piece.game.stalemate?(opponent_king) #ideally we can make sure this never happens by limiting promotion choices
        @piece.game.user_turn == @piece.game.white_user_id ? other_player = "Black" : other_player = "White"
        flash[:notice] = other_player + " is in stalemate! Game is a draw."
      else
      @piece.game.determine_check(opponent_king) # set check field in game model
      @piece.game.finish_turn(@piece.user) # next player's turn
      flash[:notice] = "Pawn promoted!"
    end
    else
      # promote failed so move pawn back, don't advance turn
      @piece.update_attributes(x_position: @old_x, y_position: @old_y)
      flash[:alert] = "Could not promote pawn!"
    end
    redirect_to game_path(@piece.game)
  end

  private

  helper_method :current_game, :show_piece_td

  def flash_notice
    if @piece.flash_message.present?
      flash[:alert] = @piece.flash_message
    end
  end

  def current_game
    @piece = Piece.find(params[:id])
    @current_game ||= @piece.game
  end

  def board_display_piece_query(row, column)
    current_game.pieces.find do |f|
      f["x_position"] == column && f["y_position"] == row
    end
  end

  def show_piece_td(row, column)
    @current_game = current_game
    find_piece = board_display_piece_query(row, column)
    board_square = "<td class='x-position-'#{column}' "
    board_square += "piece-id-data='#{piece_id(find_piece)}' "
    board_square += "piece-type-data='#{piece_type(find_piece)}''>"
    url = piece_path(Piece.find(params[:id]))
    url += "?x=#{column}&y=#{row}"
    if find_piece.nil?
      board_square += ActionController::Base.helpers.link_to '',
                                                             url, method: :put
    else
      image = ActionController::Base.helpers.image_tag find_piece
              .image_name, size: '40x45',
                           class: 'img-responsive center-block'
      board_square += ActionController::Base.helpers.link_to image,
                                                             url, method: :put
    end
    board_square + "</td>"
  end

  def piece_id(piece)
    piece.present? ? piece.id : nil
  end

  def piece_type(piece)
    piece.present? ? piece.piece_type : nil
  end

  def game_must_not_be_over
    # run before any pieces controller action
    if !current_game.game_winner.nil?
      current_game.game_winner == current_game.black_user_id ? winner = "black" : winner = "white"
      flash[:alert] = "Game is over, " + winner + " wins!"
      redirect_to game_path(current_game) and return
    elsif current_game.draw?
      current_game.user_turn == current_game.white_user_id ? current_turn = "White" : current_turn = "Black"
      flash[:info] = "Game is a draw! " + current_turn + " can't move without going into check!"
      redirect_to game_path(current_game) and return
    end 
  end

  def must_be_users_turn
    # run before any pieces controller action
    if current_user.id != current_game.user_turn
      flash[:alert] = "Not your turn!"
      redirect_to game_path(current_game)
    end
  end

  def must_be_users_piece
    # run before any pieces controller action
    if @piece.user.nil? || current_user.id != @piece.user.id
      flash[:alert] = "Not your piece!"
      redirect_to game_path(current_game)
    end
  end

  def pawn_update_params
    params.require(:pawn).permit(:piece_type)
  end

end
