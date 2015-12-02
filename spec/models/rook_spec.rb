require 'rails_helper'

RSpec.describe Rook, type: :model do
  it "should be true when moving 1 space up" do
    rook = Rook.new(x_position: 1, y_position: 0)
    actual = rook.valid_move?(1, 1)
    expect(actual).to be(true)
  end

  it "should be true when moving 2 spaces right" do
    rook = Rook.new(x_position: 1, y_position: 0)
    actual = rook.valid_move?(3, 0)
    expect(actual).to be(true)
  end

  it "should be true when moving 3 spaces left" do
    rook = Rook.new(x_position: 4, y_position: 3)
    actual = rook.valid_move?(1, 3)
    expect(actual).to be(true)
  end

  it "should be true when moving 4 spaces down" do
    rook = Rook.new(x_position: 4, y_position: 4)
    actual = rook.valid_move?(4, 0)
    expect(actual).to be(true)
  end

  it "should be false when moving 1 space diagonal" do
    rook = Rook.new(x_position: 1, y_position: 0)
    actual = rook.valid_move?(2, 1)
    expect(actual).to be(false)
  end

  it "should be false when moving 3 spaces diagonally" do
    rook = Rook.new(x_position: 1, y_position: 0)
    actual = rook.valid_move?(4, 3)
    expect(actual).to be(false)
  end
end
