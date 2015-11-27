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
    # do I even need start_x/y or can I use x/y_position directly?
    start_x = x_position # do I need the 'self' here? - I don't think so
    start_y = y_position
    delta_x = dest_x - start_x
    delta_y = dest_y - start_y

    # Should I use the "Case" syntax here to define the different directional options?
      # horizontal only delta_y == 0
      # vertical only delta_x == 0
      # diagonal delta_x == delta_y
      # invalid is when none of the above evaluates as true

    # Should I use "Case" to determine if the direction of travel is pos or neg?
    # Is there a way to write this so that it works in either direction with a single method?


  end
end
