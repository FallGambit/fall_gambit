require 'rails_helper'

RSpec.describe PiecesController, type: :controller do
  before :each do
    @current_game = FactoryGirl.build(:game)
    @current_game.assign_attributes(user_turn: @current_game.white_user_id)
    @current_game.save!
    @black_user = @current_game.black_user
    @white_user = @current_game.white_user
    sign_in @white_user
    @current_game.pieces.delete_all
  end

  describe "movement" do
    context "when the tile is not empty" do
      it "captures the opponent piece and moves to the new coordinates" do
        white_king = King.create(x_position: 1, y_position: 1,
                                 game_id: @current_game.id, color: true, user_id: @current_game.white_user_id)
        black_knight = Knight.create(x_position: 2, y_position: 2,
                                     game_id: @current_game.id, color: false, user_id: @current_game.black_user_id)
        # need both kings for checkmate logic
        black_king = King.create(x_position: 7, y_position: 7,
                                     game_id: @current_game.id, color: false, user_id: @current_game.black_user_id)
        put :update, id: white_king.id, x: 2, y: 2
        white_king.reload
        black_knight.reload
        expect(white_king.x_position).to eq(2)
        expect(white_king.y_position).to eq(2)
        expect(black_knight.captured).to be(true)
        expect(black_knight.x_position).to be_nil
        expect(black_knight.y_position).to be_nil
      end
    end
    context "tries to capture a piece with an invalid move" do
      it "king doesn't capture a piece two spaces away" do
        white_king = King.create(x_position: 1, y_position: 1,
                                 game_id: @current_game.id, color: true, user_id: @current_game.white_user_id)
        put :update, id: white_king.id, x: 3, y: 3
        expect(flash[:alert]).to be_present
        expect(white_king.x_y_coords).to eq [1, 1]
        expect(response).to redirect_to(@current_game)
        # maybe test what the flash message is?
      end
    end
    context "when the pieces are of the same color" do
      it "doesn't capture a same color piece" do
        white_king = King.create(x_position: 1, y_position: 1,
                                 game_id: @current_game.id, color: true, user_id: @current_game.white_user_id)
        white_knight = Knight.create(x_position: 2, y_position: 2,
                                     game_id: @current_game.id, color: true, user_id: @current_game.white_user_id)
        put :update, id: white_king.id, x: 3, y: 3
        expect(flash[:alert]).to be_present
        expect(white_king.x_y_coords).to eq [1, 1]
        expect(response).to redirect_to(@current_game)
      end
    end
    context "when the tile is empty" do
      it "moves to the coordinates" do
        # need both kings for checkmate logic
        black_king = King.create(x_position: 7, y_position: 7, game_id: @current_game.id, user_id: @current_game.black_user_id, color: false)
        white_king = King.create(x_position: 1, y_position: 1, game_id: @current_game.id, user_id: @current_game.white_user_id, color: true)
        put :update, id: white_king.id, x: 2, y: 2
        white_king.reload
        expect(white_king.x_position).to eq(2)
        expect(white_king.y_position).to eq(2)
      end
      it "moves 2 spaces up" do
        # need both kings for checkmate logic
        black_king = King.create(x_position: 7, y_position: 7, game_id: @current_game.id, user_id: @current_game.black_user_id, color: false)
        white_king = King.create(x_position: 1, y_position: 1, game_id: @current_game.id, user_id: @current_game.white_user_id, color: true)
        put :update, id: white_king.id, x: 2, y: 2
        expected_x_y_coords = [2, 2]
        white_king.reload
        expect(white_king.x_y_coords).to eq(expected_x_y_coords)
      end

      it "will move 2 spaces up and 1 space right" do
        # need both kings for checkmate logic
        black_king = King.create(x_position: 7, y_position: 7, game_id: @current_game.id, user_id: @current_game.black_user_id, color: false)
        white_king = King.create(x_position: 5, y_position: 5, game_id: @current_game.id, user_id: @current_game.white_user_id, color: true)
        white_knight = Knight.create(x_position: 0, y_position: 0, game_id: @current_game.id, user_id: @current_game.white_user_id, color: true)
        put :update, id: white_knight.id, x: 1, y: 2
        expected_x_position = 1
        expected_y_position = 2
        white_knight.reload
        expect(white_knight.x_position).to be(expected_x_position)
        expect(white_knight.y_position).to be(expected_y_position)
      end
    end
  end

  describe "#update" do
    it "will redirect to games page" do
      knight = Knight.create(x_position: 6, y_position: 6, game_id: @current_game.id)
      put :update, id: knight.id, x: 4, y: 5
      expect(response).to redirect_to :controller => :games, :action => :show,
                                      :id => knight.game
    end
    it "will throw an error" do
      knight = Knight.create(x_position: 6, y_position: 6, game_id: @current_game.id, user_id: @current_game.white_user_id)
      put :update, id: knight.id, x: 3, y: 3
      expect(flash[:alert]).to be_present
      expect(knight.x_y_coords).to eq [6, 6]
      expect(response).to redirect_to(@current_game)
    end
    it "will not allow player to move another player's pieces" do
      current_game = FactoryGirl.build(:game)
      current_game.assign_attributes(user_turn: current_game.white_user_id)
      current_game.save!
      black_user = current_game.black_user
      white_user = current_game.white_user
      sign_in white_user
      black_pawn = current_game.pawns.where(color: false, x_position: 0).first
      put :update, id: black_pawn.id, x: 0, y: 5
      expect(response).to redirect_to(current_game)
      expect(flash[:alert]).to be_present
      expect(flash[:alert]).to match("Not your piece!")
      expect(black_pawn.x_y_coords).to eq [0,6]
    end
    it "will not let a player move until two players have joined the game" do
      current_game = FactoryGirl.build(:game)
      current_game.assign_attributes(user_turn: current_game.white_user_id, black_user_id: nil)
      current_game.save!
      white_user = current_game.white_user
      sign_in white_user
      white_pawn = current_game.pawns.where(color: true, x_position: 0).first
      put :update, id: white_pawn.id, x: 0, y: 2
      expect(response).to redirect_to(current_game)
      expect(flash[:alert]).to be_present
      expect(flash[:alert]).to match("Cannot move until both players have joined!")
      expect(white_pawn.x_y_coords).to eq [0,1]
    end
    it "will update player turn to other user after move" do
      current_game = FactoryGirl.build(:game)
      current_game.assign_attributes(user_turn: current_game.white_user_id)
      current_game.save!
      black_user = current_game.black_user
      white_user = current_game.white_user
      sign_in white_user
      white_pawn = current_game.pawns.where(color: true, x_position: 0).first
      put :update, id: white_pawn.id, x: 0, y: 2
      expect(response).to redirect_to(current_game)
      expect(flash[:alert]).to be_nil
      white_pawn.reload
      expect(white_pawn.x_y_coords).to eq [0,2]
      current_game.reload
      expect(current_game.user_turn).to eq current_game.black_user_id
    end
    it "will set winner when they place opposing king in checkmate" do
      current_game = FactoryGirl.build(:game)
      current_game.assign_attributes(user_turn: current_game.black_user_id)
      current_game.save!
      black_user = current_game.black_user
      white_user = current_game.white_user
      sign_in black_user
      current_game.pieces.delete_all
      white_king = King.create(color: true, game_id: current_game.id, user_id: current_game.white_user_id, x_position: 0, y_position: 0)
      black_king = King.create(color: false, game_id: current_game.id, user_id: current_game.black_user_id, x_position: 7, y_position: 7)
      black_queen = Queen.create(color: false, game_id: current_game.id, user_id: current_game.black_user_id, x_position: 6, y_position: 1)
      black_pawn = Pawn.create(color: false, game_id: current_game.id, user_id: current_game.black_user_id, x_position: 2, y_position: 2)
      expect(current_game.game_winner).to be_nil
      put :update, id: black_queen.id, x: 1, y: 1
      current_game.reload
      expect(current_game.game_winner).to eq current_game.black_user_id
      expect(flash[:notice]).to eq("Checkmate! You win!")
      expect(response).to redirect_to(current_game)
      # turn should change to loser
      expect(current_game.user_turn).to eq current_game.white_user_id
    end
    it "will set stalement when opposing player cannot move without going into check" do
      current_game = FactoryGirl.build(:game)
      current_game.assign_attributes(user_turn: current_game.black_user_id)
      current_game.save!
      black_user = current_game.black_user
      white_user = current_game.white_user
      sign_in black_user
      current_game.pieces.delete_all
      white_king = King.create(color: true, game_id: current_game.id, user_id: current_game.white_user_id, x_position: 5, y_position: 0)
      black_pawn = Pawn.create(color: false, game_id: current_game.id, user_id: current_game.black_user_id, x_position: 5, y_position: 1)
      black_king = King.create(color: false, game_id: current_game.id, user_id: current_game.black_user_id, x_position: 5, y_position: 3)

      expect(current_game.draw?).to eq false
      put :update, id: black_king.id, x: 5, y: 2
      current_game.reload
      expect(current_game.draw?).to eq true
      expect(flash[:notice]).to eq("White is in stalemate! Game is a draw.")
      expect(response).to redirect_to(current_game)
      # turn should change to next player
      expect(current_game.user_turn).to eq current_game.white_user_id
    end
    it "will redirect to promotion_choice view if pawn moved to final row" do
      
    end
  end

  describe "#show" do
    it "will redirect to game show until two players have joined the game" do
      current_game = FactoryGirl.build(:game)
      current_game.assign_attributes(user_turn: current_game.white_user_id, black_user_id: nil)
      current_game.save!
      white_user = current_game.white_user
      sign_in white_user
      white_pawn = current_game.pawns.where(color: true, x_position: 0).first
      put :show, id: white_pawn.id
      expect(response).to redirect_to(current_game)
    end
    it "will redirect to game show when a player has won" do
      current_game = FactoryGirl.build(:game)
      current_game.assign_attributes(user_turn: current_game.white_user_id, game_winner: current_game.black_user_id)
      current_game.save!
      white_user = current_game.white_user
      sign_in white_user
      white_pawn = current_game.pawns.where(color: true, x_position: 0).first
      put :show, id: white_pawn.id
      expect(response).to redirect_to(current_game)
      expect(flash[:alert]).to eq("Game is over, black wins!")
    end
    it "will redirect to game show when game is a draw" do
      current_game = FactoryGirl.build(:game)
      current_game.assign_attributes(user_turn: current_game.white_user_id, draw: true)
      current_game.save!
      white_user = current_game.white_user
      sign_in white_user
      white_pawn = current_game.pawns.where(color: true, x_position: 0).first
      put :show, id: white_pawn.id
      expect(response).to redirect_to(current_game)
      expect(flash[:notice]).to eq("Game is a draw! White can't move without going into check!")
    end
  end

  describe '#promotion_choice' do
    it "will remove queen from radio button list if promoting from pawn will cause stalemate" do
      
    end
    it "will produce choices for Queen, Knight, Rook, Bishop if they do not cause stalemate when promoted to" do
      
    end
    it "will leave pawn in original pre-move position when displaying promotion choice view" do
      
    end
  end

  describe '#promote_pawn' do
    it "will promote pawn to queen" do
      
    end
    it "will promote pawn to knight" do
      
    end
    it "will promote pawn to rook" do
      
    end
    it "will promote pawn to bishop" do
      
    end
    it "will set check if promoted piece places opponent king in check" do
      
    end
    it "will set next player's turn after piece promotion" do
      
    end
    it "will redirect to game show view after piece promotion" do
      
    end
  end
end
