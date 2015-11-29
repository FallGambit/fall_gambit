require 'rails_helper'

RSpec.describe King, type: :model do
  it "should be true when moving 1 space up" do
    king = King.new(x_position: 1, y_position: 0)
    actual = king.valid_move?(1, 1)
    expect(actual).to be(true)
  end

  it "should be true when moving 1 space diagonal" do
    king = King.new(x_position: 1, y_position: 0)
    actual = king.valid_move?(2, 1)
    expect(actual).to be(true)
  end

  it "should be false when moving 2 spaces right" do
    king = King.new(x_position: 1, y_position: 0)
    actual = king.valid_move?(3, 0)
    expect(actual).to be(false)
  end

  it "should be false when moving 3 spaces diagonally" do
    king = King.new(x_position: 1, y_position: 0)
    actual = king.valid_move?(4, 3)
    expect(actual).to be(false)
  end

  it "should be false when moving 3 spaces back diagonally" do
    king = King.new(x_position: 4, y_position: 3)
    actual = king.valid_move?(1, 0)
    expect(actual).to be(false)
  end

  it "should be false when moving 3 spaces down" do
    king = King.new(x_position: 4, y_position: 3)
    actual = king.valid_move?(4, 0)
    expect(actual).to be(false)
  end
end
