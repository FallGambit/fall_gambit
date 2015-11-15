require 'rails_helper'

RSpec.describe Game, type: :model do

  describe 'instantiation' do
    let!(:game) { build(:game) }

    it 'instantiates a game' do
      expect(game.class.name).to eq("Game")
    end
  end

  it "has none to begin with" do
    expect(Game.count).to eq 0
  end

  context "with valid params" do
    it "has one after adding one" do
      testgame = create(:game)
      expect(Game.count).to eq 1
    end
  end
  context "with invalid params" do
    it "does not accept blank game name" do
      game = build(:game, game_name: "")
      game.valid?
      expect(game.errors[:game_name].size).to eq 1
    end
  end
end
