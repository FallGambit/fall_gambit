require 'rails_helper'

RSpec.describe Piece, type: :model do
  let(:game) { create(:game) }
  describe "instantiation" do
    it "sets the white queen image correctly" do
      expect(game.queens.where(color: true).first.image_name)
        .to eq('white-queen.png')
    end

    it "won't allow pieces to be created outside of board" do
      king = King.create(user_id: game.white_user_id, x_position: -1,
                         y_position: 4)
      queen = Queen.create(user_id: game.black_user_id, x_position: 4,
                           y_position: 9)
      pawn = Pawn.create(user_id: game.white_user_id, x_position: 9,
                         y_position: 9)
      knight = Knight.create(user_id: game.black_user_id, x_position: -1,
                             y_position: -1)
      expect(king).not_to be_valid
      expect(queen).not_to be_valid
      expect(pawn).not_to be_valid
      expect(knight).not_to be_valid
    end
  end

  describe "moving pieces" do
    it "won't allow pieces to be moved outside of board" do
      king = game.kings.first
      expect(king).to be_valid
      king.update_attributes(x_position: -1)
      expect(king).not_to be_valid
      king.update_attributes(x_position: 11)
      expect(king).not_to be_valid
      king.errors.clear
      king.update_attributes(y_position: -1)
      expect(king).not_to be_valid
      king.errors.clear
      king.update_attributes(y_position: 11)
      expect(king).not_to be_valid
      king.errors.clear
      king.update_attributes(x_position: -1, y_position: -1)
      expect(king).not_to be_valid
      king.errors.clear
      king.update_attributes(x_position: 11, y_position: 11)
      expect(king).not_to be_valid
      king.errors.clear
      king.update_attributes(x_position: -1, y_position: 11)
      expect(king).not_to be_valid
      king.errors.clear
    end
  end

  describe "#move_to!" do
    context "when the tile is empty" do
      it "moves to the coordinates" do
        board = create(:game)
        board.pieces.delete_all
        king = King.create(x_position: 1, y_position: 1, game_id: board.id)
        king.move_to!(2, 2)
        expect(king.x_position).to eq(2)
        expect(king.y_position).to eq(2)
      end
    end
    context "when the tile is not empty" do
      it "captures the opponent piece and moves to the new coordinates" do
        board = create(:game)
        board.pieces.delete_all
        white_king = King.create(x_position: 1, y_position: 1,
                                 game_id: board.id, color: true)
        black_knight = Knight.create(x_position: 2, y_position: 2,
                                     game_id: board.id, color: false)

        white_king.move_to!(2, 2)
        expect(white_king.x_position).to eq(2)
        expect(white_king.y_position).to eq(2)
        black_knight.reload
        expect(black_knight.captured).to be(true)
        expect(black_knight.x_position).to be_nil
        expect(black_knight.y_position).to be_nil
      end
    end
    context "tries to capture a piece with an invalid move" do
      it "king doesn't capture a piece two spaces away" do
        board = create(:game)
        board.pieces.delete_all
        white_king = King.create(x_position: 1, y_position: 1,
                                 game_id: board.id, color: true)
        black_knight = Knight.create(x_position: 3, y_position: 3,
                                     game_id: board.id, color: false)

        expect { white_king.move_to!(3, 3) }
          .to raise_error(/Invalid/)
      end
    end
    context "when the pieces are of the same color" do
      it "doesn't capture a same color piece" do
        board = create(:game)
        board.pieces.delete_all
        white_king = King.create(x_position: 1, y_position: 1,
                                 game_id: board.id, color: true)
        white_knight = Knight.create(x_position: 2, y_position: 2,
                                     game_id: board.id, color: true)

        expect { white_king.move_to!(2, 2) }
          .to raise_error(/Invalid/)
      end
    end
  end
end
