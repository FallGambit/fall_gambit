class Piece < ActiveRecord::Base
  belongs_to :user
  belongs_to :game

  # Lines 7-17 all part of STI: to break it disable line 6 or give it
  # fake field name ~AMP
  self.inheritance_column = :piece_type
  scope :pawns, -> { where(piece_type: "Pawn") }
  scope :queens, -> { where(piece_type: "Queen") }
  scope :kings, -> { where(piece_type: "King") }
  scope :rooks, -> { where(piece_type: "Rook") }
  scope :knights, -> { where(piece_type: "Knight") }
  scope :bishops, -> { where(piece_type: "Bishop") }

  def self.piece_types
    %w(Pawn Queen King Rook Knight Bishop)
  end

  def x_y_coords
    x_y_coordinates = []
    x_y_coordinates << x_position
    x_y_coordinates << y_position
    x_y_coordinates
  end

  def is_obstructed?(x, y)
    dest_x = x
    dest_y = y
    state_x = x_position 
    state_y = y_position
    delta_x = dest_x - state_x
    delta_y = dest_y - state_y
    game = Game.find(game_id)

    if delta_y == 0 && delta_x > 0 && delta_x.abs > 1
      # horizontal move where start is < destination and distance > 1
      game.pieces.where("y_position = ? AND x_position BETWEEN ? AND ?", state_y, (state_x+1), (dest_x-1)).any?
    elsif delta_y == 0 && delta_x < 0 && delta_x.abs > 1
      # horizontal move where start is > destination and distance > 1
      game.pieces.where("y_position = ? AND x_position BETWEEN ? AND ?", state_y, (dest_x+1), (state_x-1)).any?
    elsif delta_y == 0 && delta_x.abs <= 1
      # horizontal move to next square
      false
    elsif delta_x == 0 && delta_y > 0 && delta_y.abs > 1
      # vertical move where start is < destination and distance > 1
      game.pieces.where("x_position = ? AND y_position BETWEEN ? AND ?", state_x, (state_y+1), (dest_y-1)).any?
    elsif delta_x == 0 && delta_y < 0 && delta_y.abs > 1
      # vertical move where start is > destination and distance > 1
      game.pieces.where("y_position = ? AND x_position BETWEEN ? AND ?", state_x, (dest_y+1), (state_y-1)).any?
    elsif delta_x == 0 && delta_y.abs <= 1
      # vertical move to next square
      false
    elsif delta_x == delta_y
      delta_x.abs.times do 
        
      end
      
      
      
      


    # Should I use the "Case" syntax here to define the different directional options?
      # horizontal only delta_y == 0
      # vertical only delta_x == 0
      # diagonal delta_x == delta_y
      # invalid is when none of the above evaluates as true

    # Is there a way to write this so that it works in either direction with a single method?
  end

end
