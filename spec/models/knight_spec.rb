require 'rails_helper'

RSpec.describe Knight, type: :model do
<<<<<<< Updated upstream
  describe valid_move? do
    before :all do
      @game = FactoryGirl.create(:game)
      @game.pieces.delete

    end
    
=======

  describe 'valid_move?' do
    before :all do
      @game = FactoryGirl.create(:game)
      @bknight1 = Piece.find(25)
      @bknight2 = Piece.find(26)
      @wknight1 = Piece.find(9)
      @wknight2 = Piece.find(10)
      @bpawn1 = Piece.find(17)
      @bpawn1.update(y_position: 5)
      @bpawn4 = Piece.find(20)
      @bpawn5 = Piece.find(21)
      @bpawn8 = Piece.find(24)
      @bpawn8.update(y_position: 5)
      @wpawn1 = Piece.find(1)
      @wpawn1.update(y_position: 2)
      @wpawn4 = Piece.find(4)
      @wpawn5 = Piece.find(5)
      @wpawn8 = Piece.find(8)
      @wpawn8.update(y_position: 2)
    end

    context "same-color obstructions all false" do
      it 'will be false S2W1 same-color obstruction' do
        expect(@bknight1.valid_move?(5, 0)).to eq false
      end

      it 'will be false S2E1 same-color obstruction' do
        expect(@bknight2.valid_move?(5, 7)).to eq false
      end

      it 'will be false S1E2 same-color obstruction' do
        expect(@bknight1.valid_move?(6, 3)).to eq false
      end

      it 'will be false S1W2 same-color obstruction' do
        expect(@bknight2.valid_move?(6, 4)).to eq false
      end

      it 'will be false N2W1 same-color obstruction' do
        expect(@wknight1.valid_move?(2, 0)).to eq false
      end

      it 'will be false N2E1 same-color obstruction' do
        expect(@wknight2.valid_move?(2, 7)).to eq false
      end

      it 'will be false N1E2 same-color obstruction' do
        expect(@wknight1.valid_move?(1, 3)).to eq false
      end

      it 'will be false N1W2 same-color obstruction' do
        expect(@wknight2.valid_move?(1, 4)).to eq false
      end
    end

    context "opposite-color obstructions all true" do
      before :all do
        @bpawn1.update(image_name: "white-pawn.png", color: true)
        @bpawn4.update(image_name: "white-pawn.png", color: true)
        @bpawn5.update(image_name: "white-pawn.png", color: true)
        @bpawn8.update(image_name: "white-pawn.png", color: true)
        @wpawn1.update(image_name: "black-pawn.png", color: false)
        @wpawn4.update(image_name: "black-pawn.png", color: false)
        @wpawn5.update(image_name: "black-pawn.png", color: false)
        @wpawn8.update(image_name: "black-pawn.png", color: false)
      end

      it 'will be true S1E2 opposite-color obstruction' do
        expect(@bknight1.valid_move?(6, 3)).to eq true
      end

      it 'will be true S1W2 opposite-color obstruction' do
        expect(@bknight2.valid_move?(6, 4)).to eq true
      end

      it 'will be true S2W1 opposite-color obstruction' do
        expect(@bknight1.valid_move?(5, 0)).to eq true
      end

      it 'will be true S2E1 opposite-color obstruction' do
        expect(@bknight2.valid_move?(5, 7)).to eq true
      end

      it 'will be true N2W1 opposite-color obstruction' do
        expect(@wknight1.valid_move?(0, 2)).to eq true
      end

      it 'will be true N2E1 opposite-color obstruction' do
        expect(@wknight2.valid_move?(2, 7)).to eq true
      end

      it 'will be true N1E2 opposite-color obstruction' do
        expect(@wknight1.valid_move?(1, 3)).to eq true
      end

      it 'will be true N1W2 opposite-color obstruction' do
        expect(@wknight2.valid_move?(1, 4)).to eq true
      end
    end

    context "no obstruction all true" do
      before :all do
        @bpawn4.delete
        @bpawn5.delete
        @wpawn4.delete
        @wpawn5.delete
      end

      it 'will be true S2E1 no obstruction' do
        expect(@bknight1.valid_move?(5, 2)).to eq true
      end

      it 'will be true S2W1 no obstruction' do
        expect(@bknight2.valid_move?(5, 5)).to eq true
      end

      it 'will be true S1E2 no obstruction' do
        expect(@bknight1.valid_move?(6, 3)).to eq true
      end

      it 'will be true S1W2 no obstruction' do
        expect(@bknight2.valid_move?(6, 4)).to eq true
      end

      it 'will be true N1E2 no obstruction' do
        expect(@wknight1.valid_move?(1, 3)).to eq true
      end

      it 'will be true N1W2 no obstruction' do
        expect(@wknight2.valid_move?(1, 4)).to eq true
      end

      it 'will be true N2E1 no obstruction' do
        expect(@wknight1.valid_move?(2, 2)).to eq true
      end

      it 'will be true N2W1 no obstruction' do
        expect(@wknight2.valid_move?(2, 5)).to eq true
      end
    end
>>>>>>> Stashed changes
  end
end
