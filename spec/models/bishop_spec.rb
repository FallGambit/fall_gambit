require 'rails_helper'

RSpec.describe Bishop, type: :model do
  let(:game) { create(:game) }
  describe "moving" do
    context "valid moves" do
      it "validates moves" do
        # try just to test valid_move? and not is_obstructed
        bishop_game = create(:game)
        # pawns to the diagonal of bottom-left bishop
        lpawn = bishop_game.pawns.where(x_position: 1, y_position: 1).first
        rpawn = bishop_game.pawns.where(x_position: 1, y_position: 1).first
        bishop = bishop_game.bishops.where(x_position: 2, y_position: 0).first
        # is obstructed should return false for these
        # may need to change this based on how destination
        # position is implemneted...
        # this will be invalidated by the move_to method later on
        # move diagonally one space (left and right)
        expect(bishop.valid_move?(3, 1)).to be true
        expect(bishop.valid_move?(1, 1)).to be true
        # move pawns out of the way
        lpawn.update_attributes(y_position: 2)
        rpawn.update_attributes(y_position: 2)
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
        # (uncomment when is_obstructed works as intended)
        # expect(bishop.valid_move?(4, 2).to be false
        bishop.update_attributes(y_position: 4)
        # can't move down, right, up in middle of board
        expect(bishop.valid_move?(2, 2)).to be false
        expect(bishop.valid_move?(4, 4)).to be false
        expect(bishop.valid_move?(2, 6)).to be false
      end
    end
  end
end
