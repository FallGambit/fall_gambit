require 'test_helper'

class GameTest < ActiveSupport::TestCase
  test "should not save game without name" do
    game = Game.new
    assert_not game.save, "Saved game without a name"
  end

  test "should save game with name" do
    game = Game.new(:game_name => "test")
    assert game.save, "Did not save a game with a name"
  end
end
