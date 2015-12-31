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
          board.assign_attributes(last_moved_piece_id: black_pawn.id, last_moved_prev_x_pos: 4, last_moved_prev_y_pos: 6)
          board.save(validate: false)
          white_pawn = Pawn.create(x_position: 5, y_position: 4, game_id: board.id, color: true, has_moved: true)
          board.reload
          expect(white_pawn.valid_move?(4, 5)).to be true
        end
        it "will let adjacent pawn capture enemy pawn that moved 2 spaces as immediate next move - right" do
          board = create(:game)
          board.pieces.delete_all
          black_pawn = Pawn.create(x_position: 6, y_position: 4, game_id: board.id, color: false, has_moved: true)
          board.assign_attributes(last_moved_piece_id: black_pawn.id, last_moved_prev_x_pos: 6, last_moved_prev_y_pos: 6)
          board.save(validate: false)
          white_pawn = Pawn.create(x_position: 5, y_position: 4, game_id: board.id, color: true, has_moved: true)
          board.reload
          expect(white_pawn.valid_move?(6, 5)).to be true
        end
        it "will not let adjacent pawn capture enemy pawn that moved 2 spaces if not the immediate next move - left" do
          board = create(:game)
          board.pieces.delete_all
          black_king = King.create(x_position: 0, y_position: 7, game_id: board.id, color: false, has_moved: true)
          black_pawn = Pawn.create(x_position: 4, y_position: 4, game_id: board.id, color: false, has_moved: true)
          board.assign_attributes(last_moved_piece_id: black_king.id, last_moved_prev_x_pos: 1, last_moved_prev_y_pos: 7)
          board.save(validate: false)
          white_pawn = Pawn.create(x_position: 5, y_position: 4, game_id: board.id, color: true, has_moved: true)
          board.reload
          expect(white_pawn.valid_move?(4, 5)).to be false
        end
        it "will not let adjacent pawn capture enemy pawn that moved 2 spaces if not the immediate next move - right" do
          board = create(:game)
          board.pieces.delete_all
          black_king = King.create(x_position: 0, y_position: 7, game_id: board.id, color: false, has_moved: true)
          black_pawn = Pawn.create(x_position: 6, y_position: 4, game_id: board.id, color: false, has_moved: true)
          board.assign_attributes(last_moved_piece_id: black_king.id, last_moved_prev_x_pos: 1, last_moved_prev_y_pos: 7)
          board.save(validate: false)
          white_pawn = Pawn.create(x_position: 5, y_position: 4, game_id: board.id, color: true, has_moved: true)
          board.reload
          expect(white_pawn.valid_move?(6, 5)).to be false
        end
        it "will not allow move if enemy pawn only moved one space" do
          board = create(:game)
          board.pieces.delete_all
          black_pawn = Pawn.create(x_position: 4, y_position: 4, game_id: board.id, color: false, has_moved: true)
          board.assign_attributes(last_moved_piece_id: black_pawn.id, last_moved_prev_x_pos: 4, last_moved_prev_y_pos: 5)
          board.save(validate: false)
          white_pawn = Pawn.create(x_position: 5, y_position: 4, game_id: board.id, color: true, has_moved: true)
          board.reload
          expect(white_pawn.valid_move?(4, 5)).to be false
        end
        it "will not allow move if enemy piece is not a pawn" do
          board = create(:game)
          board.pieces.delete_all
          black_queen = Queen.create(x_position: 4, y_position: 4, game_id: board.id, color: false, has_moved: true)
          board.assign_attributes(last_moved_piece_id: black_queen.id, last_moved_prev_x_pos: 4, last_moved_prev_y_pos: 6)
          board.save(validate: false)
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
          board.assign_attributes(last_moved_piece_id: white_pawn.id, last_moved_prev_x_pos: 4, last_moved_prev_y_pos: 1)
          board.save(validate: false)
          black_pawn = Pawn.create(x_position: 5, y_position: 3, game_id: board.id, color: false, has_moved: true)
          board.reload
          expect(black_pawn.valid_move?(4, 2)).to be true
        end
        it "will let adjacent pawn capture enemy pawn that moved 2 spaces as immediate next move - right" do
          board = create(:game)
          board.pieces.delete_all
          white_pawn = Pawn.create(x_position: 6, y_position: 3, game_id: board.id, color: true, has_moved: true)
          board.assign_attributes(last_moved_piece_id: white_pawn.id, last_moved_prev_x_pos: 6, last_moved_prev_y_pos: 1)
          board.save(validate: false)
          black_pawn = Pawn.create(x_position: 5, y_position: 3, game_id: board.id, color: false, has_moved: true)
          board.reload
          expect(black_pawn.valid_move?(6, 2)).to be true
        end
        it "will not let adjacent pawn capture enemy pawn that moved 2 spaces if not the immediate next move - left" do
          board = create(:game)
          board.pieces.delete_all
          white_king = King.create(x_position: 0, y_position: 0, game_id: board.id, color: true, has_moved: true)
          white_pawn = Pawn.create(x_position: 4, y_position: 3, game_id: board.id, color: true, has_moved: true)
          board.assign_attributes(last_moved_piece_id: white_king.id, last_moved_prev_x_pos: 1, last_moved_prev_y_pos: 0)
          board.save(validate: false)
          black_pawn = Pawn.create(x_position: 5, y_position: 3, game_id: board.id, color: false, has_moved: true)
          board.reload
          expect(black_pawn.valid_move?(4, 2)).to be false
        end
        it "will not let adjacent pawn capture enemy pawn that moved 2 spaces if not the immediate next move - right" do
          board = create(:game)
          board.pieces.delete_all
          white_king = King.create(x_position: 0, y_position: 0, game_id: board.id, color: true, has_moved: true)
          white_pawn = Pawn.create(x_position: 6, y_position: 3, game_id: board.id, color: true, has_moved: true)
          board.assign_attributes(last_moved_piece_id: white_king.id, last_moved_prev_x_pos: 1, last_moved_prev_y_pos: 0)
          board.save(validate: false)
          black_pawn = Pawn.create(x_position: 5, y_position: 3, game_id: board.id, color: false, has_moved: true)
          board.reload
          expect(black_pawn.valid_move?(6, 2)).to be false
        end
        it "will not allow move if enemy pawn only moved one space" do
          board = create(:game)
          board.pieces.delete_all
          white_pawn = Pawn.create(x_position: 4, y_position: 3, game_id: board.id, color: true, has_moved: true)
          board.assign_attributes(last_moved_piece_id: white_pawn.id, last_moved_prev_x_pos: 4, last_moved_prev_y_pos: 2)
          board.save(validate: false)
          black_pawn = Pawn.create(x_position: 5, y_position: 3, game_id: board.id, color: false, has_moved: true)
          board.reload
          expect(black_pawn.valid_move?(4, 2)).to be false
        end
        it "will not allow move if enemy piece is not a pawn" do
          board = create(:game)
          board.pieces.delete_all
          white_queen = Queen.create(x_position: 4, y_position: 3, game_id: board.id, color: true, has_moved: true)
          board.assign_attributes(last_moved_piece_id: white_queen.id, last_moved_prev_x_pos: 4, last_moved_prev_y_pos: 1)
          board.save(validate: false)
          black_pawn = Pawn.create(x_position: 5, y_position: 3, game_id: board.id, color: false, has_moved: true)
          board.reload
          expect(black_pawn.valid_move?(4, 2)).to be false
        end
      end
    end
  end
  describe "#promotion" do
    context "white pawn" do
      it "promotes to queen" do
        board = create(:game)
        board.pieces.delete_all
        white_pawn = Pawn.create(x_position: 6, y_position: 7, game_id: board.id, color: true)
        expect(white_pawn.promote?).to eq true
        expect(white_pawn.promote!("Queen")).to eq true
        white_pawn = Piece.find(white_pawn.id)
        expect(white_pawn.is_a?(Queen)).to eq true
        expect(white_pawn.piece_type).to eq "Queen"
        expect(white_pawn.image_name).to eq "white-queen.png"
      end
      it "promotes to knight" do
        board = create(:game)
        board.pieces.delete_all
        white_pawn = Pawn.create(x_position: 6, y_position: 7, game_id: board.id, color: true)
        expect(white_pawn.promote?).to eq true
        expect(white_pawn.promote!("Knight")).to eq true
        white_pawn = Piece.find(white_pawn.id)
        expect(white_pawn.is_a?(Knight)).to eq true
        expect(white_pawn.piece_type).to eq "Knight"
        expect(white_pawn.image_name).to eq "white-knight.png"
      end
      it "promotes to rook" do
        board = create(:game)
        board.pieces.delete_all
        white_pawn = Pawn.create(x_position: 6, y_position: 7, game_id: board.id, color: true)
        expect(white_pawn.promote?).to eq true
        expect(white_pawn.promote!("Rook")).to eq true
        white_pawn = Piece.find(white_pawn.id)
        expect(white_pawn.is_a?(Rook)).to eq true
        expect(white_pawn.piece_type).to eq "Rook"
        expect(white_pawn.image_name).to eq "white-rook.png"
      end
      it "promotes to bishop" do
        board = create(:game)
        board.pieces.delete_all
        white_pawn = Pawn.create(x_position: 6, y_position: 7, game_id: board.id, color: true)
        expect(white_pawn.promote?).to eq true
        expect(white_pawn.promote!("Bishop")).to eq true
        white_pawn = Piece.find(white_pawn.id)
        expect(white_pawn.is_a?(Bishop)).to eq true
        expect(white_pawn.piece_type).to eq "Bishop"
        expect(white_pawn.image_name).to eq "white-bishop.png"
      end
      it "does not promote to pawn" do
        board = create(:game)
        board.pieces.delete_all
        white_pawn = Pawn.create(x_position: 6, y_position: 7, game_id: board.id, color: true)
        expect(white_pawn.promote?).to eq true
        expect(white_pawn.promote!("Pawn")).to eq false
        white_pawn = Piece.find(white_pawn.id)
        expect(white_pawn.is_a?(Pawn)).to eq true
        expect(white_pawn.piece_type).to eq "Pawn"
        expect(white_pawn.image_name).to eq "white-pawn.png"
      end
      it "does not promote to king" do
        board = create(:game)
        board.pieces.delete_all
        white_pawn = Pawn.create(x_position: 6, y_position: 7, game_id: board.id, color: true)
        expect(white_pawn.promote?).to eq true
        expect(white_pawn.promote!("King")).to eq false
        white_pawn = Piece.find(white_pawn.id)
        expect(white_pawn.is_a?(Pawn)).to eq true
        expect(white_pawn.piece_type).to eq "Pawn"
        expect(white_pawn.image_name).to eq "white-pawn.png"
      end
      it "does not promote if not on last row" do
        board = create(:game)
        board.pieces.delete_all
        white_pawn = Pawn.create(x_position: 6, y_position: 6, game_id: board.id, color: true)
        expect(white_pawn.promote?).to eq false
        expect(white_pawn.promote!("Queen")).to eq false
        white_pawn = Piece.find(white_pawn.id)
        expect(white_pawn.is_a?(Pawn)).to eq true
        expect(white_pawn.piece_type).to eq "Pawn"
        expect(white_pawn.image_name).to eq "white-pawn.png"
      end
    end
    context "black pawn" do
      it "promotes to queen" do
        board = create(:game)
        board.pieces.delete_all
        black_pawn = Pawn.create(x_position: 6, y_position: 0, game_id: board.id, color: false)
        expect(black_pawn.promote?).to eq true
        expect(black_pawn.promote!("Queen")).to eq true
        black_pawn = Piece.find(black_pawn.id)
        expect(black_pawn.is_a?(Queen)).to eq true
        expect(black_pawn.piece_type).to eq "Queen"
        expect(black_pawn.image_name).to eq "black-queen.png"
      end
      it "promotes to knight" do
        board = create(:game)
        board.pieces.delete_all
        black_pawn = Pawn.create(x_position: 6, y_position: 0, game_id: board.id, color: false)
        expect(black_pawn.promote?).to eq true
        expect(black_pawn.promote!("Knight")).to eq true
        black_pawn = Piece.find(black_pawn.id)
        expect(black_pawn.is_a?(Knight)).to eq true
        expect(black_pawn.piece_type).to eq "Knight"
        expect(black_pawn.image_name).to eq "black-knight.png"
      end
      it "promotes to rook" do
        board = create(:game)
        board.pieces.delete_all
        black_pawn = Pawn.create(x_position: 6, y_position: 0, game_id: board.id, color: false)
        expect(black_pawn.promote?).to eq true
        expect(black_pawn.promote!("Rook")).to eq true
        black_pawn.promote!("Rook")
        black_pawn = Piece.find(black_pawn.id)
        expect(black_pawn.is_a?(Rook)).to eq true
        expect(black_pawn.piece_type).to eq "Rook"
        expect(black_pawn.image_name).to eq "black-rook.png"
      end
      it "promotes to bishop" do
        board = create(:game)
        board.pieces.delete_all
        black_pawn = Pawn.create(x_position: 6, y_position: 0, game_id: board.id, color: false)
        expect(black_pawn.promote?).to eq true
        expect(black_pawn.promote!("Bishop")).to eq true
        black_pawn = Piece.find(black_pawn.id)
        expect(black_pawn.is_a?(Bishop)).to eq true
        expect(black_pawn.piece_type).to eq "Bishop"
        expect(black_pawn.image_name).to eq "black-bishop.png"
      end
      it "does not promote to pawn" do
        board = create(:game)
        board.pieces.delete_all
        black_pawn = Pawn.create(x_position: 6, y_position: 0, game_id: board.id, color: false)
        expect(black_pawn.promote?).to eq true
        expect(black_pawn.promote!("Pawn")).to eq false
        black_pawn = Piece.find(black_pawn.id)
        expect(black_pawn.is_a?(Pawn)).to eq true
        expect(black_pawn.piece_type).to eq "Pawn"
        expect(black_pawn.image_name).to eq "black-pawn.png"
      end
      it "does not promote to king" do
        board = create(:game)
        board.pieces.delete_all
        black_pawn = Pawn.create(x_position: 6, y_position: 0, game_id: board.id, color: false)
        expect(black_pawn.promote?).to eq true
        expect(black_pawn.promote!("King")).to eq false
        black_pawn = Piece.find(black_pawn.id)
        expect(black_pawn.is_a?(Pawn)).to eq true
        expect(black_pawn.piece_type).to eq "Pawn"
        expect(black_pawn.image_name).to eq "black-pawn.png"
      end
      it "does not promote if not on last row" do
        board = create(:game)
        board.pieces.delete_all
        black_pawn = Pawn.create(x_position: 6, y_position: 1, game_id: board.id, color: false)
        expect(black_pawn.promote?).to eq false
        expect(black_pawn.promote!("Queen")).to eq false
        black_pawn = Piece.find(black_pawn.id)
        expect(black_pawn.is_a?(Pawn)).to eq true
        expect(black_pawn.piece_type).to eq "Pawn"
        expect(black_pawn.image_name).to eq "black-pawn.png"
      end
    end
  end
end
