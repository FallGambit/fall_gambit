require 'rails_helper'

RSpec.describe King, type: :model do
  describe 'valid_move?' do
    before :all do
      @game = FactoryGirl.create(:game)
      @game.pieces.destroy_all
      @wking = King.create(x_position: 4, y_position: 3, game_id: @game.id, color: true)
      @wpawn = Pawn.create(x_position: 3, y_position: 2, game_id: @game.id, color: true)
      @bpawn = Pawn.create(x_position: 5, y_position: 2, game_id: @game.id, color: false)
    end

    it "should be true when moving 1 space up" do
      actual = @wking.valid_move?(4, 4)
      expect(actual).to be(true)
    end

    it "should be true when moving 1 space diagonal" do
      actual = @wking.valid_move?(5, 4)
      expect(actual).to be(true)
    end

    it "should be false when moving 2 spaces right" do
      actual = @wking.valid_move?(6, 3)
      expect(actual).to be(false)
    end

    it "should be false when moving 3 spaces diagonally" do
      actual = @wking.valid_move?(7, 6)
      expect(actual).to be(false)
    end

    it "should be false when moving 3 spaces back diagonally" do
      actual = @wking.valid_move?(1, 0)
      expect(actual).to be(false)
    end

    it "should be false when moving 3 spaces down" do
      actual = @wking.valid_move?(4, 0)
      expect(actual).to be(false)
    end

    it "should be false when moving onto tile with same colored piece" do
      actual = @wking.valid_move?(3, 2)
      expect(actual).to be(false)
    end

    it "should be true when moving onto tile with different colored piece" do
      actual = @wking.valid_move?(5, 2)
      expect(actual).to be(true)
    end

    it "should be false when moving off the board" do
      actual = @wking.valid_move?(-1, 2)
      expect(actual).to be(false)
    end
  end
end
