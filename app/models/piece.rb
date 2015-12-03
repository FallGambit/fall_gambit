class Piece < ActiveRecord::Base
  belongs_to :user
  belongs_to :game
  validates :x_position, :presence => true,
                         :numericality => { greater_than_or_equal_to: 0,
                                            less_than_or_equal_to: 7 },
                         allow_nil: true
  validates :y_position, :presence => true,
                         :numericality => { greater_than_or_equal_to: 0,
                                            less_than_or_equal_to: 7 },
                         allow_nil: true
  after_initialize :set_image

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
    false
  end

  def set_image
    color ? color_string = "white" : color_string = "black"
    self.image_name ||= "#{color_string}-#{piece_type.downcase}.png"
  end

  def move_to!(x, y)
    @target = game.pieces.where(:x_position => x, :y_position => y).take
    if @target.nil?
      update_attributes(:x_position => x, :y_position => y)
    else
      if color != @target.color
        capture(x, y)
      else
        fail "Invalid move: you can't capture one of your pieces"
      end
    end
  end

  def capture(x, y)
    update_attributes(:x_position => x, :y_position => y)
    @target.update_attributes(:captured => true,
                              :x_position => nil,
                              :y_position => nil)
  end
end
