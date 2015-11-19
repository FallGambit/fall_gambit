require 'rails_helper'

RSpec.describe Game, type: :model do
  describe 'instantiation' do
    let(:build_game) { build(:game) }
    let(:game) { create(:game) }

    it 'instantiates a game' do
      expect(build_game.class.name).to eq("Game")
    end

    it "has none to begin with" do
      expect(Game.count).to eq 0
    end

    context "with valid params" do
      it "populates the board with 32 pieces" do
        expect(game.pieces.count).to eq 32
      end

      it "has count of one after adding one" do
        game
        expect(Game.count).to eq 1
      end

      def find_color_piece_type(target_color, target_type)
        # helper method to simplify database search for piece type by color
        # may end up rolling this into the game model (then we can get rid
        # of it here)
        if target_color == :white
          color_value = true
        elsif target_color == :black
          color_value = false
        end
        game.pieces
          .where("color = ? AND piece_type =?", color_value, target_type)
      end

      # these tests assume no flipping of board perspective, white is on bottom
      context "while placing white pieces" do
        it "places the pawns in the correct squares" do
          # This creates an array of all x positions, and deletes each position
          # if it's found in the list of pawns (they all have the same y
          # coordinate). This checks the correct positions and intrinsically
          # provides a count of the pawns.
          x_list = *(0..7)
          find_color_piece_type(:white, "Pawn").each do |pawn|
            expect(x_list.delete_at(x_list.find_index(pawn.x_position)))
              .not_to be_nil
            expect(pawn.y_position).to eq 1
          end
          expect(x_list.empty?).to eq true
        end

        it "places the king in the correct square" do
          x_y_coords = find_color_piece_type(:white, "King").first.x_y_coords
          expect(x_y_coords).to eq([4, 0])
        end

        it "places the queen in the correct square" do
          x_y_coords = find_color_piece_type(:white, "Queen").first.x_y_coords
          expect(x_y_coords).to eq([3, 0])
        end

        it "places the knight in the correct square" do
          x_y_coord_list = []
          find_color_piece_type(:white, "Knight").each do |knight|
            x_y_coord_list << knight.x_y_coords
          end
          expect(x_y_coord_list).to include([1, 0], [6, 0])
        end

        it "places the bishop in the correct square" do
          x_y_coord_list = []
          find_color_piece_type(:white, "Bishop").each do |bishop|
            x_y_coord_list << bishop.x_y_coords
          end
          expect(x_y_coord_list).to include([2, 0], [5, 0])
        end

        it "places the rook in the correct square" do
          x_y_coord_list = []
          find_color_piece_type(:white, "Rook").each do |rook|
            x_y_coord_list << rook.x_y_coords
          end
          expect(x_y_coord_list).to include([0, 0], [7, 0])
        end
      end

      # these tests assume no flipping of board perspective, black is on top
      context "while placing black pieces" do
        it "places the pawns in the correct squares" do
          # This creates an array of all x positions, and deletes each position
          # if it's found in the list of pawns (they all have the same y-
          # coordinate). This checks the correct positions and intrinsically
          # provides a count of the pawns.
          x_list = *(0..7)
          find_color_piece_type(:black, "Pawn").each do |pawn|
            expect(x_list.delete_at(x_list.find_index(pawn.x_position)))
              .not_to be_nil
            expect(pawn.y_position).to eq 6
          end
          expect(x_list.empty?).to eq true
        end

        it "places the king in the correct square" do
          x_y_coords = find_color_piece_type(:black, "King").first.x_y_coords
          expect(x_y_coords).to eq([4, 7])
        end

        it "places the queen in the correct square" do
          x_y_coords = find_color_piece_type(:black, "Queen").first.x_y_coords
          expect(x_y_coords).to eq([3, 7])
        end

        it "places the knight in the correct square" do
          x_y_coord_list = []
          find_color_piece_type(:black, "Knight").each do |knight|
            x_y_coord_list << knight.x_y_coords
          end
          expect(x_y_coord_list).to include([1, 7], [6, 7])
        end

        it "places the bishop in the correct square" do
          x_y_coord_list = []
          find_color_piece_type(:black, "Bishop").each do |bishop|
            x_y_coord_list << bishop.x_y_coords
          end
          expect(x_y_coord_list).to include([2, 7], [5, 7])
        end

        it "places the rook in the correct square" do
          x_y_coord_list = []
          find_color_piece_type(:black, "Rook").each do |rook|
            x_y_coord_list << rook.x_y_coords
          end
          expect(x_y_coord_list).to include([0, 7], [7, 7])
        end
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
end
