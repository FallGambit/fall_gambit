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
    new_x = params[:x].to_i
    new_y = params[:y].to_i
    if @piece.piece_type == "Pawn" && @piece.promote_at?(new_x, new_y) # pawn can be promoted
      # set global variables for new view and form submission- kind of ugly, but it works
      # need to do this in case the user does not submit the promotion form, need to revert piece(s) to 
      # previous state(s)
      $old_x = @piece.x_position
      $old_y = @piece.y_position
      $intended_x = new_x
      $intended_y = new_y
      redirect_to promotion_choice_piece_path(@piece) and return
    end
    if @piece.move_to!(new_x, new_y)
      opponent_king = @piece.game.kings.where.not(color: @piece.color).first
      if @piece.game.checkmate?(opponent_king) # current player placed other player in checkmate - wins!
        @piece.game.update_attributes(game_winner: @piece.user_id) # set game winner
        flash[:notice] = "Checkmate! You win!" # will only get set and display on winner's turn
        update_game_listing # refresh game listing in real-time
      else
        # check for stalemate of other player after move and set game model field
        if @piece.game.stalemate!(opponent_king)
          @piece.game.user_turn == @piece.game.white_user_id ? other_player = "Black" : other_player = "White"
          flash[:notice] = other_player + " is in stalemate! Game is a draw."
          update_game_listing # refresh game listing in real-time
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
      PrivatePub.publish_to("/", "window.location.reload();")
    rescue Errno::ECONNREFUSED
      # flash.now[:alert] = "Pushing to Faye Failed"
      return
    end
  end

  def promotion_choice
    # can/should eventually move this logic into a model
    # make sure choices don't place opponent into stalemate, pass choices to radio buttons in form
    dest_piece = @piece.game.pieces.where(x_position: $intended_x, y_position: $intended_y).first
    if !dest_piece.nil? 
      dest_piece.update_attributes(x_position: nil, y_position: nil, captured: true) # temp capture to check for stalemate
    end
    @piece.update_attributes(x_position: $intended_x, y_position: $intended_y) # temp move to check for stalemate
    # need to loop through Queen and Knight to check for stalemate on promotion
    @promotion_check_for_stalemate = %w(Queen Knight)
    @button_list = [] # will show up as radio buttons passed to the user input form
    @promotion_check_for_stalemate.each do |promo|
      @piece.promote!(promo) # try promoting piece to Queen/Knight
      @piece = Piece.find(params[:id]) #reload new type
      if !@piece.game.stalemate?(@piece.game.kings.where.not(color: @piece.color).first) # doesn't put game into stalemate
        @button_list << [promo, promo] # add piece to possible promotion type if it doesn't cause a stalemate
      end
      # reset piece to Pawn so promote! can be called again since it's a pawn method
      @piece.update(piece_type: "Pawn")
      @piece.save!
      @piece = Piece.find(params[:id]) # reload original pawn instance type
    end
    # can always pick rook and bishop
    @button_list << ['Rook', 'Rook'] << ['Bishop', 'Bishop']
    # full list passed to user input form (if no stalemates) should be:
    #@button_list = [['Queen', 'Queen'],['Knight', 'Knight'],['Rook', 'Rook'],['Bishop', 'Bishop']]
    # reset pawn/captured piece to previous positions in case promotion cancelled without submitting form
    if !dest_piece.nil? 
      dest_piece.update_attributes(x_position: $intended_x, y_position: $intended_y, captured: false) # reset
    end
    @piece.update_attributes(x_position: $old_x, y_position: $old_y) # reset
  end

  def promote_pawn
    # perform the actual promotion and moving of the piece on form submission
    if @piece.move_to!($intended_x, $intended_y) #try to move piece
      type_update = pawn_update_params[:piece_type] # grab from input form params
      if @piece.promote!(type_update) # was promotion succesful?
        @piece = Piece.find(params[:id]) #reload as new piece type
        # check for checkmate, stalemate, or determine check and advance turn
        # a lot of this is pulled from move_to!, but we have to check again with the new piece type
        opponent_king = @piece.game.kings.where.not(color: @piece.color).first
        if @piece.game.checkmate?(opponent_king) # current player placed other player in checkmate - wins!
          @piece.game.update_attributes(game_winner: @piece.user_id) # set game winner
          flash[:notice] = "Checkmate! You win!" # will only get set and display on winner's turn
        elsif @piece.game.stalemate!(opponent_king) #ideally we can make sure this never happens by limiting promotion choices
          @piece.game.user_turn == @piece.game.white_user_id ? other_player = "Black" : other_player = "White"
          flash[:notice] = other_player + " is in stalemate! Game is a draw."
        else
        @piece.game.determine_check(opponent_king) # set check field in game model
        @piece.game.finish_turn(@piece.user) # next player's turn
        flash[:notice] = "Pawn promoted!"
        end
      else
        # promote failed so move pawn back, don't advance turn
        @piece.update_attributes(x_position: $old_x, y_position: $old_y)
        flash[:alert] = "Could not promote pawn!"
      end
    end
    redirect_to game_path(@piece.game)
    begin
      PrivatePub.publish_to("/games/#{@piece.game.id}", "window.location.reload();")
    rescue Errno::ECONNREFUSED
      # flash.now[:alert] = "Pushing to Faye Failed"
      return
    end
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
      flash[:notice] = "Game is a draw! " + current_turn + " can't move without going into check!"
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

  def update_game_listing
    begin
      # update game listing in real time
      PrivatePub.publish_to("/", "window.location.reload();")
    rescue Errno::ECONNREFUSED
      #flash.now[:alert] = "Pushing to Faye Failed"
    end
  end

  def pawn_update_params
    params.require(:pawn).permit(:piece_type)
  end

end
