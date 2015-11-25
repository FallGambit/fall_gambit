require 'rails_helper'

RSpec.describe Piece, type: :model do
  describe 'is_obstructed' do
    before :each do
      @game = FactoryGirl.create(:game)
      @wq #instance white queen at [0,2]
      @wkn #instance white knight at [0,1]
      @wp #instance white pawn at [1,1]
      @wb #instance white bishop at [4,2]
      @bp #instance black bishop at [2,4]
    it 'evaluates as false when diagonal path point x1y1 to point x2y2 is clear'
      #how the fuck do I test this let alone build it?
      #do I have to populate a whole game board?
      #diag case for every delta of x corresponding delta of y
      expect(delta_x).to eql(delta_y)
      expect(examine_path)

    it 'evaluates as false when horizontal axis path xy1 to point xy2 is clear'


      expect(delta_x).to eq(0) # or expect x1 eql x2, establishes horizontal movement
      expect(is_obstructed())

    it 'evaluates as false when vertical axis path x1y to point x2y is clear'  
    it 'evaluates as true when there is a block in horizontal axis'
    it 'evaluates as true when there is a block in vertical axis'
    it 'evaluates as true when there is a block in the diagonal'
    it 'will raise an Error Message with invalid input' 
      #cases of invalid input should include endpoint off the board or non-diag, non-linear endpoint
    it 'evaluates as false when path is clear and destination contains a piece'
  end
end
