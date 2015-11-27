require 'rails_helper'

RSpec.describe Piece, type: :model do
  describe 'is_obstructed?' do
    before :all do
      # @user = FactoryGirl.create(:user)
      # sign_in @user
      @game = FactoryGirl.create(:game)
      @game.pieces.delete
      @white_queen = Queen.create(
        x_position: 0,
        y_position: 2,
        color: true,
        game_id: @game.id,
        captured: false
        ) 
      @white_knight = Knight.create(
        x_position: 0,
        y_position: 1,
        color: true,
        game_id: @game.id,
        captured: false
        ) 
      @white_pawn = Pawn.create(
        x_position: 1,
        y_position: 1,
        color: true,
        game_id: @game.id,
        captured: false
        ) 
      @white_bishop = Bishop.create(
        x_position: 4,
        y_position: 2,
        color: true, 
        game_id: @game.id,
        captured: false
        )  
      @black_pawn = Pawn.create(
        x_position: 4,
        y_position: 6,
        color: false,
        game_id: @game.id,
        captured: false
        ) 
    end

    it 'evaluates as false when diagonal path is clear' do
      expect(@white_queen.is_obstructed?(2,4)).to be_falsey
    end

    it 'evaluates as false when horizontal axis path is clear' do
      expect(@white_queen.is_obstructed?(3,2)).to be_falsey
    end

    it 'evaluates as false when vertical axis path is clear' do
      expect(@white_queen.is_obstructed?(0,5)).to be_falsey
    end

    it 'evaluates as true when there is a block in horizontal axis' do
      expect(@white_queen.is_obstructed?(5,2)).to be_truthy
    end

    it 'evaluates as true when there is a block in vertical axis' do
      expect(@white_queen.is_obstructed?(0,0)).to be_truthy
    end

    it 'evaluates as true when there is a block in the diagonal' do
      expect(@white_queen.is_obstructed?(2,0)).to be_truthy
    end

    it 'will raise an Error Message with invalid input' do 
      expect(@white_queen.is_obstructed?(3,4)).to raise_error # add "invalid input"
    end

    it 'evaluates as false when PATH is clear but DESTINATION contains a piece' do
      expect(@white_queen.is_obstructed?(1,1)).to be_falsey
    end

    # it 'evaluates as true when path is clear but destination contains same-color' do
    #   expect(@white_queen.is_obstructed?(4,2)).to be_truthy
    # end # this will probably be covered by is_valid

  end
end
