require 'rails_helper'

RSpec.describe Piece, type: :model do
  it "has valid factory" do
    expect(build(:piece)).to be_valid
  end
  describe "#move_to!" do
    let(:king) { create(:king, x_position: 1, y_position: 1) }
    context "when the tile is empty" do
      it "moves to the coordinates" do
        king.move_to!(2, 2)
        expect(king.x_position).to eq(2)
        expect(king.y_position).to eq(2)
      end
    end
    context "when the tile is not empty" do
      let(:white_king) { create(:king, color: true) }
      let!(:black_knight) { create(:knight, color: false) }
      it "captures the opponent piece and moves to the new coordinates" do
        white_king.move_to!(2, 2)

        expect(white_king.x_position).to eq(2)
        expect(white_king.y_position).to eq(2)

        black_knight.reload
        expect(black_knight.captured).to be(true)
        expect(black_knight.x_position).to be_nil
        expect(black_knight.y_position).to be_nil
      end
    end
    context "when the pieces are of the same color" do
      let(:white_king) { create(:king, color: true) }
      let!(:white_knight) { create(:knight, color: true) }
      it "doesn't capture a same color piece" do
        expect { white_king.move_to!(2, 2) }.to raise_error("Invalid move!")
      end
    end
  end
end
