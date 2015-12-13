require 'rails_helper'

RSpec.describe Queen, type: :model do
  describe "valid_move?" do
    before :all do
      @board = create(:game)
      @board.pieces.delete_all
      @board.reload
    end

    context "no obstruction, no end piece, all pass: " do
      before :all do
        @white_queen = Queen.create(
          x_position: 3,
          y_position: 3,
          color: true,
          game_id: @board.id
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

    context "no obstruction, opposite color end piece, all pass: " do
      before :all do
        @black_queen = Queen.create(
          x_position: 3,
          y_position: 2,
          color: false,
          game_id: @board.id
          )
        @white_queen = Queen.create(
          x_position: 3,
          y_position: 0,
          color: true,
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
      end

      it "diagonal +X +Y" do

      end
      it "diagonal +X -Y" do

      end
      it "diagonal -X -Y" do

      end
      it "diagonal -X +Y" do

      end
      it "vertical +Y" do

      end
      it "vertical -Y" do

      end
      it "horizontal +X" do

      end
      it "horizontal -X" do

      end
    end

    context "no obstruction, same color end piece, all fail: " do
      it "diagonal +X +Y" do

      end
      it "diagonal +X -Y" do

      end
      it "diagonal -X -Y" do

      end
      it "diagonal -X +Y" do

      end
      it "vertical +Y" do

      end
      it "vertical -Y" do

      end
      it "horizontal +X" do

      end
      it "horizontal -X" do

      end
    end

    context "with obstruction, all fail: " do
      it "diagonal +X +Y" do

      end
      it "diagonal +X -Y" do

      end
      it "diagonal -X -Y" do

      end
      it "diagonal -X +Y" do

      end
      it "vertical +Y" do

      end
      it "vertical -Y" do

      end
      it "horizontal +X" do

      end
      it "horizontal -X" do

      end
    end

    context "invalid coordinates, all fail: "
  end
end
