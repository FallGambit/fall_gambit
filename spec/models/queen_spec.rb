require 'rails_helper'

RSpec.describe Queen, type: :model do
  describe "valid_move?" do
    before :all do
      @board = create(:game)
      @board.pieces.delete_all
      @board.reload
      @white_user = User.find(@board.white_user_id)
      @black_user = User.find(@black_user_id)
    end
    context "no obstruction, no end piece, all pass:" do
      before :all do
        @white_queen = Queen.create(
          x_position: 3,
          y_position: 3,
          color: true,
          game_id: @board.id
          user_id: @white_user.id
          )
      end
      it "diagonal +X +Y" do
        expect(@white_queen.valid_move?(6, 6)).to eq true
      end
      it "diagonal +X -Y" do
        expect(@white_queen.valid_move?(5, 1)).to eq true
      end
      it "diagonal -X -Y" do
        expect(@white_queen.valid_move?(1, 1)).to eq true
      end
      it "diagonal -X +Y" do
        expect(@white_queen.valid_move?(0, 6)).to eq true
      end
      it "vertical +Y" do
        expect(@white_queen.valid_move?(3, 6)).to eq true
      end
      it "vertical -Y" do
        expect(@white_queen.valid_move?(3, 0)).to eq true
      end
      it "horizontal +X" do
        expect(@white_queen.valid_move?(7, 3)).to eq true
      end
      it "horizontal -X" do
        expect(@white_queen.valid_move?(1, 3)).to eq  true
      end
    end
    context "no obstruction, opposite color end piece, all pass:" do
      before :all do
        @white_queen.update(y_position: 0)
        @black_queen = Queen.create(
          x_position: 3,
          y_position: 2,
          color: false,
          game_id: @board.id
          )
        @white_rook = Rook.create(
          x_position: 1,
          y_position: 0,
          color: true,
          game_id: @board.id
          )
        @white_pawn1 = Pawn.create(
          x_position: 1,
          y_position: 2,
          color: true,
          game_id: @board.id
          )
        @white_knight1 = Knight.create(
          x_position: 1,
          y_position: 4,
          color: true,
          game_id: @board.id
          )
        @white_bishop1 = Bishop.create(
          x_position: 3,
          y_position: 4,
          color: true,
          game_id: @board.id
          )
        @white_pawn2 = Pawn.create(
          x_position: 5,
          y_position: 4,
          color: true,
          game_id: @board.id
          )
        @white_knight2 = Knight.create(
          x_position: 5,
          y_position: 2,
          color: true,
          game_id: @board.id
          )
        @white_bishop2 = Bishop.create(
          x_position: 5,
          y_position: 0,
          color: true,
          game_id: @board.id
          )
        @
      end
      it "diagonal +X +Y" do
        expect(@black_queen.valid_move?(5, 4)).to eq true
      end
      it "diagonal +X -Y" do
        expect(@black_queen.valid_move?(5, 0)).to eq true
      end
      it "diagonal -X -Y" do
        expect(@black_queen.valid_move?(1, 0)).to eq true
      end
      it "diagonal -X +Y" do
        expect(@black_queen.valid_move?(1, 4)).to eq true
      end
      it "vertical +Y" do
        expect(@black_queen.valid_move?(3, 4)).to eq true
      end
      it "vertical -Y" do
        expect(@black_queen.valid_move?(3, 0)).to eq true
      end
      it "horizontal +X" do
        expect(@black_queen.valid_move?(5, 2)).to eq true
      end
      it "horizontal -X" do
        expect(@black_queen.valid_move?(1, 2)).to eq true
      end
    end
    context "no obstruction, same color end piece, all fail:" do
      before :all do
        byebug
        @black_queen.update(x_position: 5, y_position: 5)
        @white_queen.update(y_position: 2)
        @white_king = King.create(
          x_position: 3,
          y_position: 0,
          color: true,
          game_id: @board.id
          )
      end
      it "diagonal +X +Y" do
        expect(@white_queen.valid_move?(5, 4)).to eq false
      end
      it "diagonal +X -Y" do
        expect(@white_queen.valid_move?(5, 0)).to eq false
      end
      it "diagonal -X -Y" do
        expect(@white_queen.valid_move?(1, 0)).to eq false
      end
      it "diagonal -X +Y" do
        expect(@white_queen.valid_move?(1, 4)).to eq false
      end
      it "vertical +Y" do
        expect(@white_queen.valid_move?(3, 4)).to eq false
      end
      it "vertical -Y" do
        expect(@white_queen.valid_move?(3, 0)).to eq false
      end
      it "horizontal +X" do
        expect(@white_queen.valid_move?(5, 2)).to eq false
      end
      it "horizontal -X" do
        expect(@white_queen.valid_move?(1, 2)).to eq false
      end
    end
    context "with obstruction, all fail:" do
      before :all do
        @black_pawn1 = Pawn.create(
          x_position: 4,
          y_position: 6,
          color: false,
          game_id: @board.id
          )
        @black_pawn2 = Pawn.create(
          x_position: 5,
          y_position: 6,
          color: false,
          game_id: @board.id
          )
        @black_pawn3 = Pawn.create(
          x_position: 6,
          y_position: 6,
          color: false,
          game_id: @board.id
          )
        @black_rook = Rook.create(
          x_position: 6,
          y_position: 5,
          color: false,
          game_id: @board.id
          )
        @black_bishop = Bishop.create(
          x_position: 4,
          y_position: 5,
          color: false,
          game_id: @board.id
          )
        @white_pawn3 = Pawn.create(
          x_position: 4,
          y_position: 4,
          color: false,
          game_id: @board.id
          )
        @white_pawn4 = Pawn.create(
          x_position: 6,
          y_position: 4,
          color: false,
          game_id: @board.id
          )
      end
      it "diagonal +X +Y" do
        expect(@black_queen.valid_move?(7, 7)).to eq false
      end
      it "diagonal +X -Y" do
        expect(@black_queen.valid_move?(7, 3)).to eq false
      end
      it "diagonal -X -Y" do
        expect(@black_queen.valid_move?(3, 3)).to eq false
      end
      it "diagonal -X +Y" do
        expect(@black_queen.valid_move?(3, 7)).to eq false
      end
      it "vertical +Y" do
        expect(@black_queen.valid_move?(5, 7)).to eq false
      end
      it "vertical -Y" do
        expect(@black_queen.valid_move?(5, 3)).to eq false
      end
      it "horizontal +X" do
        expect(@black_queen.valid_move?(7, 5)).to eq false
      end
      it "horizontal -X" do
        expect(@black_queen.valid_move?(3, 5)).to eq false
      end
    end
    context "invalid coordinates, all fail:" do
      it "tries to move off the board" do
        expect(@black_queen.valid_move?(8, 2)).to eq false
      end
      it "tries to make invalid move" do
        expect(@white_queen.valid_move?(1, 3)).to eq false
      end
    end
    after :all do
      @board.pieces.delete_all
      @board.delete
    end
  end
end
