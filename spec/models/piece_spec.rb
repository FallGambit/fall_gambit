require 'rails_helper'

RSpec.describe Piece, type: :model do
  let(:game) { create(:game) }
  describe "instantiation" do
    it "sets the white queen image correctly" do
      expect(game.queens.where(color: true).first.image_name)
        .to eq('white-queen.png')
    end
  end
end
