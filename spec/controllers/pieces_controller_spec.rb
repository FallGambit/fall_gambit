require 'rails_helper'

RSpec.describe PiecesController, type: :controller do
  before :each do
    @black_user = FactoryGirl.create(:user)
    @white_user = FactoryGirl.create(:user)
    sign_in @white_user
    sign_in @black_user
    @current_game = FactoryGirl.create(:game)
    @current_game.pieces.delete_all
  end

  describe "movement" do
    context "when the tile is not empty" do
      it "captures the opponent piece and moves to the new coordinates" do
        white_king = King.create(x_position: 1, y_position: 1,
                                 game_id: @current_game.id, color: true)
        black_knight = Knight.create(x_position: 2, y_position: 2,
                                     game_id: @current_game.id, color: false)

        put :update, id: white_king.id, x: 2, y: 2
        white_king.reload
        black_knight.reload
        expect(white_king.x_position).to eq(2)
        expect(white_king.y_position).to eq(2)
        expect(black_knight.captured).to be(true)
        expect(black_knight.x_position).to be_nil
        expect(black_knight.y_position).to be_nil
      end
    end
    context "tries to capture a piece with an invalid move" do
      it "king doesn't capture a piece two spaces away" do
        white_king = King.create(x_position: 1, y_position: 1,
                                 game_id: @current_game.id, color: true)

        expect { put :update, id: white_king.id, x: 3, y: 3 }
          .to raise_error(/Invalid/)
      end
    end
    context "when the pieces are of the same color" do
      it "doesn't capture a same color piece" do
        white_king = King.create(x_position: 1, y_position: 1,
                                 game_id: @current_game.id, color: true)
        white_knight = Knight.create(x_position: 2, y_position: 2,
                                     game_id: @current_game.id, color: true)

        expect { put :update, id: white_king.id, x: 3, y: 3 }
          .to raise_error(/Invalid/)
      end
    end
    context "when the tile is empty" do
      it "moves to the coordinates" do
        king = King.create(x_position: 1, y_position: 1, game_id: @current_game.id)
        put :update, id: king.id, x: 2, y: 2
        king.reload
        expect(king.x_position).to eq(2)
        expect(king.y_position).to eq(2)
      end
      it "moves 2 spaces up" do
        king = King.create(x_position: 1, y_position: 1, game_id: @current_game.id)
        put :update, id: king.id, x: 2, y: 2
        expected_x_y_coords = [2, 2]
        king.reload
        expect(king.x_y_coords).to eql(expected_x_y_coords)
      end

      it "will move 2 spaces up and 1 space right" do
        knight = Knight.create(x_position: 0, y_position: 0, game_id: @current_game.id)
        put :update, id: knight.id, x: 1, y: 2
        expected_x_position = 1
        expected_y_position = 2
        knight.reload
        expect(knight.x_position).to be(expected_x_position)
        expect(knight.y_position).to be(expected_y_position)
      end
    end
  end

  describe "#update" do
    it "will redirect to games page" do
      knight = Knight.create(x_position: 6, y_position: 6, game_id: @current_game.id)
      put :update, id: knight.id, x: 4, y: 5
      expect(response).to redirect_to :controller => :games, :action => :show,
                                      :id => knight.game
    end
    it "will throw an error" do
      knight = Knight.create(x_position: 6, y_position: 6, game_id: @current_game.id)
      expect { put :update, id: knight.id, x: 3, y: 3 }
          .to raise_error(/Invalid/)
    end
  end

  end
