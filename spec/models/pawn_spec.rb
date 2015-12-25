require 'rails_helper'

RSpec.describe Pawn, type: :model do
  describe "#valid_move?" do
    context "white moving" do
      it "should be true when moving 1 space forward" do
        board = create(:game)
        board.pieces.delete_all
        pawn = Pawn.create(x_position: 1,
                           y_position: 1,
                           game_id: board.id,
                           color: true)
        board.reload
        actual = pawn.valid_move?(1, 2)
        expect(actual).to be(true)
      end
      it "should be true when moving 2 spaces forward on first move" do
        board = create(:game)
        board.pieces.delete_all
        pawn = Pawn.create(x_position: 1,
                           y_position: 1,
                           game_id: board.id,
                           color: true)
        board.reload
        actual = pawn.valid_move?(1, 3)
        expect(actual).to be(true)
      end
      it "should be false when moving 3 space forward" do
        board = create(:game)
        board.pieces.delete_all
        pawn = Pawn.create(x_position: 1,
                           y_position: 1,
                           game_id: board.id,
                           color: true)
        board.reload
        actual = pawn.valid_move?(1, 4)
        expect(actual).to be(false)
      end
      it "should be false when moving 2 spaces forward after first move" do
        board = create(:game)
        board.pieces.delete_all
        pawn = Pawn.create(x_position: 1,
                           y_position: 2,
                           game_id: board.id,
                           color: true,
                           has_moved: true)
        board.reload
        actual = pawn.valid_move?(1, 4)
        expect(actual).to be(false)
      end
      it "should be false when moving 1 space backward" do
        board = create(:game)
        board.pieces.delete_all
        pawn = Pawn.create(x_position: 1,
                           y_position: 4,
                           game_id: board.id,
                           color: true)
        board.reload
        actual = pawn.valid_move?(1, 3)
        expect(actual).to be(false)
      end
      it "should be true when moving 1 space diagonal/left when capturing" do
        board = create(:game)
        board.pieces.delete_all
        white_pawn = Pawn.create(x_position: 1,
                                 y_position: 2,
                                 game_id: board.id,
                                 color: true)
        black_pawn = Pawn.create(x_position: 2,
                                 y_position: 3,
                                 game_id: board.id,
                                 color: false)
        board.reload
        actual = white_pawn.valid_move?(2, 3)
        expect(actual).to be(true)
      end
      it "should be true when moving 1 space diagonal/right when capturing" do
        board = create(:game)
        board.pieces.delete_all
        white_pawn = Pawn.create(x_position: 1,
                                 y_position: 2,
                                 game_id: board.id,
                                 color: true)
        black_pawn = Pawn.create(x_position: 0,
                                 y_position: 3,
                                 game_id: board.id,
                                 color: false)
        board.reload
        actual = white_pawn.valid_move?(0, 3)
        expect(actual).to be(true)
      end
      it "should be false when moving 1 space forward diagonal-right when not capturing" do
        board = create(:game)
        board.pieces.delete_all
        white_pawn = Pawn.create(x_position: 1,
                                 y_position: 1,
                                 game_id: board.id,
                                 color: true)
        board.reload
        actual = white_pawn.valid_move?(2, 2)
        expect(actual).to be(false)
      end
      it "should be false when moving 1 space forward diagonal-left when not capturing" do
        board = create(:game)
        board.pieces.delete_all
        white_pawn = Pawn.create(x_position: 1,
                                 y_position: 1,
                                 game_id: board.id,
                                 color: true)
        board.reload
        actual = white_pawn.valid_move?(0, 2)
        expect(actual).to be(false)
      end
      it "should be false when moving 2 spaces forward diagonal-right when not capturing and hasn't moved" do
        board = create(:game)
        board.pieces.delete_all
        white_pawn = Pawn.create(x_position: 2,
                                 y_position: 1,
                                 game_id: board.id,
                                 color: true)
        board.reload
        actual = white_pawn.valid_move?(4, 3)
        expect(actual).to be(false)
      end
      it "should be false when moving 2 spaces forward diagonal-left when not capturing and hasn't moved" do
        board = create(:game)
        board.pieces.delete_all
        white_pawn = Pawn.create(x_position: 2,
                                 y_position: 1,
                                 game_id: board.id,
                                 color: true)
        board.reload
        actual = white_pawn.valid_move?(0, 3)
        expect(actual).to be(false)
      end
      it "should be false when moving 1 space backwards diagonal-right when not capturing" do
        board = create(:game)
        board.pieces.delete_all
        white_pawn = Pawn.create(x_position: 1,
                                 y_position: 1,
                                 game_id: board.id,
                                 color: true)
        board.reload
        actual = white_pawn.valid_move?(2, 0)
        expect(actual).to be(false)
      end
      it "should be false when moving 1 space backward diagonal-left when not capturing" do
        board = create(:game)
        board.pieces.delete_all
        white_pawn = Pawn.create(x_position: 1,
                                 y_position: 1,
                                 game_id: board.id,
                                 color: true)
        board.reload
        actual = white_pawn.valid_move?(0, 0)
        expect(actual).to be(false)
      end
      it "should be false when moving 1 space diagonal on friendly piece" do
        board = create(:game)
        board.pieces.delete_all
        white_pawn1 = Pawn.create(x_position: 1,
                                  y_position: 2,
                                  game_id: board.id,
                                  color: true)
        white_pawn2 = Pawn.create(x_position: 0,
                                  y_position: 3,
                                  game_id: board.id,
                                  color: true)
        board.reload
        actual = white_pawn1.valid_move?(0, 3)
        expect(actual).to be(false)
      end
      it "should be false when moving 3 spaces diagonally" do
        board = create(:game)
        board.pieces.delete_all
        pawn = Pawn.create(x_position: 1,
                           y_position: 2,
                           game_id: board.id,
                           color: true)
        board.reload
        actual = pawn.valid_move?(4, 5)
        expect(actual).to be(false)
      end
      it "should be false when moving onto tile of same colored piece" do
        board = create(:game)
        board.pieces.delete_all
        pawn = Pawn.create(x_position: 1,
                           y_position: 2,
                           game_id: board.id,
                           color: true)
        knight = Knight.create(x_position: 1,
                           y_position: 3,
                           game_id: board.id,
                           color: true)
        board.reload
        actual = pawn.valid_move?(1, 3)
        expect(actual).to be(false)
      end
      it "should raise exception when moving off the board" do
        board = create(:game)
        board.pieces.delete_all
        pawn = Pawn.create(x_position: 1,
                           y_position: 2,
                           game_id: board.id,
                           color: false)
        board.reload
        actual = pawn.valid_move?(1, -1)
        expect(actual).to be(false)
      end
      context "en passant" do
        it "will let adjacent pawn capture enemy pawn that moved 2 spaces as immediate next move - left" do
          board = create(:game)
          board.pieces.delete_all
          black_pawn = Pawn.create(x_position: 4, y_position: 4, game_id: board.id, color: false, has_moved: true)
          board.update_attributes(last_moved_piece_id: black_pawn.id, last_moved_prev_x_pos: 4, last_moved_prev_y_pos: 6)
          white_pawn = Pawn.create(x_position: 5, y_position: 4, game_id: board.id, color: true, has_moved: true)
          board.reload
          expect(white_pawn.valid_move?(4, 5)).to be true
        end
        it "will let adjacent pawn capture enemy pawn that moved 2 spaces as immediate next move - right" do
          board = create(:game)
          board.pieces.delete_all
          black_pawn = Pawn.create(x_position: 6, y_position: 4, game_id: board.id, color: false, has_moved: true)
          board.update_attributes(last_moved_piece_id: black_pawn.id, last_moved_prev_x_pos: 6, last_moved_prev_y_pos: 6)
          white_pawn = Pawn.create(x_position: 5, y_position: 4, game_id: board.id, color: true, has_moved: true)
          board.reload
          expect(white_pawn.valid_move?(6, 5)).to be true
        end
        it "will not let adjacent pawn capture enemy pawn that moved 2 spaces if not the immediate next move - left" do
          board = create(:game)
          board.pieces.delete_all
          black_king = King.create(x_position: 0, y_position: 7, game_id: board.id, color: false, has_moved: true)
          black_pawn = Pawn.create(x_position: 4, y_position: 4, game_id: board.id, color: false, has_moved: true)
          board.update_attributes(last_moved_piece_id: black_king.id, last_moved_prev_x_pos: 1, last_moved_prev_y_pos: 7)
          white_pawn = Pawn.create(x_position: 5, y_position: 4, game_id: board.id, color: true, has_moved: true)
          board.reload
          expect(white_pawn.valid_move?(4, 5)).to be false
        end
        it "will not let adjacent pawn capture enemy pawn that moved 2 spaces if not the immediate next move - right" do
          board = create(:game)
          board.pieces.delete_all
          black_king = King.create(x_position: 0, y_position: 7, game_id: board.id, color: false, has_moved: true)
          black_pawn = Pawn.create(x_position: 6, y_position: 4, game_id: board.id, color: false, has_moved: true)
          board.update_attributes(last_moved_piece_id: black_king.id, last_moved_prev_x_pos: 1, last_moved_prev_y_pos: 7)
          white_pawn = Pawn.create(x_position: 5, y_position: 4, game_id: board.id, color: true, has_moved: true)
          board.reload
          expect(white_pawn.valid_move?(6, 5)).to be false
        end
        it "will not allow move if enemy pawn only moved one space" do
          board = create(:game)
          board.pieces.delete_all
          black_pawn = Pawn.create(x_position: 4, y_position: 4, game_id: board.id, color: false, has_moved: true)
          board.update_attributes(last_moved_piece_id: black_pawn.id, last_moved_prev_x_pos: 4, last_moved_prev_y_pos: 5)
          white_pawn = Pawn.create(x_position: 5, y_position: 4, game_id: board.id, color: true, has_moved: true)
          board.reload
          expect(white_pawn.valid_move?(4, 5)).to be false
        end
        it "will not allow move if enemy piece is not a pawn" do
          board = create(:game)
          board.pieces.delete_all
          black_queen = Queen.create(x_position: 4, y_position: 4, game_id: board.id, color: false, has_moved: true)
          board.update_attributes(last_moved_piece_id: black_queen.id, last_moved_prev_x_pos: 4, last_moved_prev_y_pos: 6)
          white_pawn = Pawn.create(x_position: 5, y_position: 4, game_id: board.id, color: true, has_moved: true)
          board.reload
          expect(white_pawn.valid_move?(4, 5)).to be false
        end
      end
    end

    context "black moving" do
      it "should be true when moving 1 space forward" do
        board = create(:game)
        board.pieces.delete_all
        pawn = Pawn.create(x_position: 6,
                           y_position: 6,
                           game_id: board.id,
                           color: false)
        board.reload
        actual = pawn.valid_move?(6, 5)
        expect(actual).to be(true)
      end
      it "should be true when moving 2 spaces forward on first move" do
        board = create(:game)
        board.pieces.delete_all
        pawn = Pawn.create(x_position: 6,
                           y_position: 6,
                           game_id: board.id,
                           color: false)
        board.reload
        actual = pawn.valid_move?(6, 4)
        expect(actual).to be(true)
      end
      it "should be false when moving 3 space forward" do
        board = create(:game)
        board.pieces.delete_all
        pawn = Pawn.create(x_position: 6,
                           y_position: 6,
                           game_id: board.id,
                           color: false)
        board.reload
        actual = pawn.valid_move?(6, 3)
        expect(actual).to be(false)
      end
      it "should be false when moving 2 spaces forward after first move" do
        board = create(:game)
        board.pieces.delete_all
        pawn = Pawn.create(x_position: 6,
                           y_position: 5,
                           game_id: board.id,
                           color: false,
                           has_moved: true)
        board.reload
        actual = pawn.valid_move?(6, 3)
        expect(actual).to be(false)
      end
      it "should be false when moving 1 space backward" do
        board = create(:game)
        board.pieces.delete_all
        pawn = Pawn.create(x_position: 6,
                           y_position: 3,
                           game_id: board.id,
                           color: false)
        board.reload
        actual = pawn.valid_move?(6, 4)
        expect(actual).to be(false)
      end
      it "should be true when moving 1 space diagonal/right when capturing" do
        board = create(:game)
        board.pieces.delete_all
        black_pawn = Pawn.create(x_position: 6,
                                 y_position: 5,
                                 game_id: board.id,
                                 color: false)
        white_pawn = Pawn.create(x_position: 7,
                                 y_position: 4,
                                 game_id: board.id,
                                 color: true)
        board.reload
        actual = black_pawn.valid_move?(7, 4)
        expect(actual).to be(true)
      end
      it "should be true when moving 1 space diagonal/left when capturing" do
        board = create(:game)
        board.pieces.delete_all
        black_pawn = Pawn.create(x_position: 6,
                                 y_position: 5,
                                 game_id: board.id,
                                 color: false)
        white_pawn = Pawn.create(x_position: 5,
                                 y_position: 4,
                                 game_id: board.id,
                                 color: true)
        board.reload
        actual = black_pawn.valid_move?(5, 4)
        expect(actual).to be(true)
      end
      it "should be false when moving 1 space forward diagonal-right when not capturing" do
        board = create(:game)
        board.pieces.delete_all
        black_pawn = Pawn.create(x_position: 1,
                                 y_position: 6,
                                 game_id: board.id,
                                 color: false)
        board.reload
        actual = black_pawn.valid_move?(2, 5)
        expect(actual).to be(false)
      end
      it "should be false when moving 1 space forward diagonal-left when not capturing" do
        board = create(:game)
        board.pieces.delete_all
        black_pawn = Pawn.create(x_position: 1,
                                 y_position: 6,
                                 game_id: board.id,
                                 color: false)
        board.reload
        actual = black_pawn.valid_move?(0, 5)
        expect(actual).to be(false)
      end
      it "should be false when moving 2 spaces forward diagonal-right when not capturing and hasn't moved" do
        board = create(:game)
        board.pieces.delete_all
        black_pawn = Pawn.create(x_position: 2,
                                 y_position: 6,
                                 game_id: board.id,
                                 color: false)
        board.reload
        actual = black_pawn.valid_move?(4, 4)
        expect(actual).to be(false)
      end
      it "should be false when moving 2 spaces forward diagonal-left when not capturing and hasn't moved" do
        board = create(:game)
        board.pieces.delete_all
        black_pawn = Pawn.create(x_position: 2,
                                 y_position: 6,
                                 game_id: board.id,
                                 color: false)
        board.reload
        actual = black_pawn.valid_move?(0, 4)
        expect(actual).to be(false)
      end
      it "should be false when moving 1 space backward diagonal-right when not capturing" do
        board = create(:game)
        board.pieces.delete_all
        black_pawn = Pawn.create(x_position: 1,
                                 y_position: 6,
                                 game_id: board.id,
                                 color: false)
        board.reload
        actual = black_pawn.valid_move?(2, 7)
        expect(actual).to be(false)
      end
      it "should be false when moving 1 space backward diagonal-left when not capturing" do
        board = create(:game)
        board.pieces.delete_all
        black_pawn = Pawn.create(x_position: 1,
                                 y_position: 6,
                                 game_id: board.id,
                                 color: false)
        board.reload
        actual = black_pawn.valid_move?(0, 7)
        expect(actual).to be(false)
      end
      it "should be false when moving 3 spaces diagonally" do
        board = create(:game)
        board.pieces.delete_all
        pawn = Pawn.create(x_position: 6,
                           y_position: 5,
                           game_id: board.id,
                           color: false)
        board.reload
        actual = pawn.valid_move?(3, 2)
        expect(actual).to be(false)
      end
      it "should be false when moving onto tile of same colored piece" do
        board = create(:game)
        board.pieces.delete_all
        pawn = Pawn.create(x_position: 6,
                           y_position: 5,
                           game_id: board.id,
                           color: false)
        knight = Knight.create(x_position: 6,
                           y_position: 4,
                           game_id: board.id,
                           color: false)
        board.reload
        actual = pawn.valid_move?(6, 4)
        expect(actual).to be(false)
      end
      it "should raise exception when moving off the board" do
        board = create(:game)
        board.pieces.delete_all
        pawn = Pawn.create(x_position: 6,
                           y_position: 5,
                           game_id: board.id,
                           color: false)
        board.reload
        actual = pawn.valid_move?(6, 8)
        expect(actual).to be(false)
      end
      context "en passant" do
        it "will let adjacent pawn capture enemy pawn that moved 2 spaces as immediate next move - left" do
          board = create(:game)
          board.pieces.delete_all
          white_pawn = Pawn.create(x_position: 4, y_position: 3, game_id: board.id, color: true, has_moved: true)
          board.update_attributes(last_moved_piece_id: white_pawn.id, last_moved_prev_x_pos: 4, last_moved_prev_y_pos: 1)
          black_pawn = Pawn.create(x_position: 5, y_position: 3, game_id: board.id, color: false, has_moved: true)
          board.reload
          expect(black_pawn.valid_move?(4, 2)).to be true
        end
        it "will let adjacent pawn capture enemy pawn that moved 2 spaces as immediate next move - right" do
          board = create(:game)
          board.pieces.delete_all
          white_pawn = Pawn.create(x_position: 6, y_position: 3, game_id: board.id, color: true, has_moved: true)
          board.update_attributes(last_moved_piece_id: white_pawn.id, last_moved_prev_x_pos: 6, last_moved_prev_y_pos: 1)
          black_pawn = Pawn.create(x_position: 5, y_position: 3, game_id: board.id, color: false, has_moved: true)
          board.reload
          expect(black_pawn.valid_move?(6, 2)).to be true
        end
        it "will not let adjacent pawn capture enemy pawn that moved 2 spaces if not the immediate next move - left" do
          board = create(:game)
          board.pieces.delete_all
          white_king = King.create(x_position: 0, y_position: 0, game_id: board.id, color: true, has_moved: true)
          white_pawn = Pawn.create(x_position: 4, y_position: 3, game_id: board.id, color: true, has_moved: true)
          board.update_attributes(last_moved_piece_id: white_king.id, last_moved_prev_x_pos: 1, last_moved_prev_y_pos: 0)
          black_pawn = Pawn.create(x_position: 5, y_position: 3, game_id: board.id, color: false, has_moved: true)
          board.reload
          expect(black_pawn.valid_move?(4, 2)).to be false
        end
        it "will not let adjacent pawn capture enemy pawn that moved 2 spaces if not the immediate next move - right" do
          board = create(:game)
          board.pieces.delete_all
          white_king = King.create(x_position: 0, y_position: 0, game_id: board.id, color: true, has_moved: true)
          white_pawn = Pawn.create(x_position: 6, y_position: 3, game_id: board.id, color: true, has_moved: true)
          board.update_attributes(last_moved_piece_id: white_king.id, last_moved_prev_x_pos: 1, last_moved_prev_y_pos: 0)
          black_pawn = Pawn.create(x_position: 5, y_position: 3, game_id: board.id, color: false, has_moved: true)
          board.reload
          expect(black_pawn.valid_move?(6, 2)).to be false
        end
        it "will not allow move if enemy pawn only moved one space" do
          board = create(:game)
          board.pieces.delete_all
          white_pawn = Pawn.create(x_position: 4, y_position: 3, game_id: board.id, color: true, has_moved: true)
          board.update_attributes(last_moved_piece_id: white_pawn.id, last_moved_prev_x_pos: 4, last_moved_prev_y_pos: 2)
          black_pawn = Pawn.create(x_position: 5, y_position: 3, game_id: board.id, color: false, has_moved: true)
          board.reload
          expect(black_pawn.valid_move?(4, 5)).to be false
        end
        it "will not allow move if enemy piece is not a pawn" do
          board = create(:game)
          board.pieces.delete_all
          white_queen = Queen.create(x_position: 4, y_position: 3, game_id: board.id, color: true, has_moved: true)
          board.update_attributes(last_moved_piece_id: white_queen.id, last_moved_prev_x_pos: 4, last_moved_prev_y_pos: 1)
          black_pawn = Pawn.create(x_position: 5, y_position: 3, game_id: board.id, color: false, has_moved: true)
          board.reload
          expect(black_pawn.valid_move?(4, 2)).to be false
        end
      end
    end
  end
end
