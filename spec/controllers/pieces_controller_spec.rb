require 'rails_helper'

RSpec.describe PiecesController, type: :controller do
  before :all do
    @black_user = FactoryGirl.create(:user)
    @white_user = FactoryGirl.create(:user)
    sign_in @white_user
    sign_in @black_user
    @current_game = FactoryGirl.create(:game, :white_user => @white_user.id, :black_user => @black_user.id)
  end

  describe "pawn should move" do
    it "will move" do
      controller = PiecesController.new
      @piece = Piece.where(x_position: 6, y_position: 6).first
      put :update
      controller.instance_eval{ show_piece_td(6, 5) } 
      expect{ @piece.x_y_coords }.to eq ([6, 5])
    end
  end
  after :all do
    @current_game.delete
    Piece.delete_all
  end
end
