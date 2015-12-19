require 'rails_helper'

RSpec.describe Bishop, type: :model do
  let(:game) { create(:game) }
  describe "moving" do
    context "valid moves" do
      it "validates moves" do
        # try just to test valid_move? and not is_obstructed
        bishop_game = create(:game)
        bishop_game.pieces.destroy_all
        # pawns to the diagonal of bottom-left bishop
        lpawn = Pawn.create(x_position: 1, y_position: 2, game_id: bishop_game.id)
        rpawn = Pawn.create(x_position: 3, y_position: 2, game_id: bishop_game.id)
        bishop = Bishop.create(x_position: 2, y_position: 0, game_id: bishop_game.id)
        # is obstructed should return false for these
        # may need to change this based on how destination
        # position is implemneted...
        # this will be invalidated by the move_to method later on
        # move diagonally one space (left and right)
        expect(bishop.valid_move?(3, 1)).to be true
        expect(bishop.valid_move?(1, 1)).to be true
        # try moving around a diamond shape
        expect(bishop.valid_move?(4, 2)).to be true
        # this is just updating attributes, so pieces can move through others
        bishop.update_attributes(x_position: 4, y_position: 2)
        expect(bishop.valid_move?(2, 4)).to be true
        bishop.update_attributes(x_position: 2, y_position: 4)
        expect(bishop.valid_move?(0, 6)).to be true
        expect(bishop.valid_move?(0, 2)).to be true
        bishop.update_attributes(x_position: 0, y_position: 2)
        expect(bishop.valid_move?(2, 0)).to be true
        bishop.update_attributes(x_position: 2, y_position: 0)
      end
    end
    context "invalid moves" do
      it "invalidates moves" do
        bishop_game = create(:game)
        bishop = bishop_game.bishops.where(x_position: 2, y_position: 0).first
        # can't move left, right, or up from starting position
        expect(bishop.valid_move?(1, 0)).to be false
        expect(bishop.valid_move?(3, 0)).to be false
        expect(bishop.valid_move?(2, 1)).to be false
        # one check for is_obstructed
        # expect(bishop.valid_move?(4, 2).to be false
        bishop.update_attributes(y_position: 4)
        # can't move down, right, up in middle of board
        expect(bishop.valid_move?(2, 2)).to be false
        expect(bishop.valid_move?(4, 4)).to be false
        expect(bishop.valid_move?(2, 6)).to be false
        # can't move off the board
        expect(bishop.valid_move?(-1, 1)).to be false
        # can't move onto tile of same colored piece
        expect{bishop.valid_move?(3, 1)}.to raise_error(RuntimeError)
      end
    end
  end
end
