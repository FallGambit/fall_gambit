require 'rails_helper'

RSpec.describe Rook, type: :model do
  before :all do
    @board = create(:game)
    @board.pieces.delete_all
  end

  it "should be true when moving 1 space up" do
    rook = Rook.create(x_position: 1, y_position: 0, game_id: @board.id)
    @board.reload
    actual = rook.valid_move?(1, 1)
    expect(actual).to be(true)
  end

  it "should be true when moving 2 spaces right" do
    rook = Rook.create(x_position: 1, y_position: 0, game_id: @board.id)
    @board.reload
    actual = rook.valid_move?(3, 0)
    expect(actual).to be(true)
  end

  it "should be true when moving 3 spaces left" do
    rook = Rook.create(x_position: 4, y_position: 3, game_id: @board.id)
    @board.reload
    actual = rook.valid_move?(1, 3)
    expect(actual).to be(true)
  end

  it "should be true when moving 4 spaces down" do
    rook = Rook.create(x_position: 4, y_position: 4, game_id: @board.id)
    @board.reload
    actual = rook.valid_move?(4, 0)
    expect(actual).to be(true)
  end

  it "should be false when moving 1 space diagonal" do
    rook = Rook.create(x_position: 1, y_position: 0, game_id: @board.id)
    @board.reload
    actual = rook.valid_move?(2, 1)
    expect(actual).to be(false)
  end

  it "should be false when moving 3 spaces diagonally" do
    rook = Rook.create(x_position: 1, y_position: 0, game_id: @board.id)
    @board.reload
    actual = rook.valid_move?(4, 3)
    expect(actual).to be(false)
  end
  it "should be false when moving onto tile with same colored piece" do
    rook = Rook.create(x_position: 4, y_position: 4, game_id: @board.id)
    rook = Rook.create(x_position: 6, y_position: 4, game_id: @board.id)
    @board.reload
    actual = rook.valid_move?(6, 4)
    expect(actual).to be(false)
  end
  it "should be false when there is a piece in the way" do
    rook1 = Rook.create(x_position: 4, y_position: 4, game_id: @board.id)
    rook2 = Rook.create(x_position: 5, y_position: 4, game_id: @board.id)
    @board.reload
    actual = rook1.valid_move?(6, 4)
    expect(actual).to be(false)
  end
  it "should be false when moving off the board" do
    rook = Rook.create(x_position: 4, y_position: 4, game_id: @board.id)
    @board.reload
    actual = rook.valid_move?(-1, 4)
    expect(actual).to be(false)
  end
end
