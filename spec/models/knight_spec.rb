require 'rails_helper'

RSpec.describe Knight, type: :model do
  describe valid_move? do
    before :all do
      @game = FactoryGirl.create(:game)
      @game.pieces.delete

    end
    
  end
end
