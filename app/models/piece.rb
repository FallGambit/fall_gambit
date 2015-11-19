class Piece < ActiveRecord::Base
  belongs_to :game
  belongs_to :user

  def x_y_coords
    x_y_coordinates = []
    x_y_coordinates << x_position
    x_y_coordinates << y_position
    x_y_coordinates
  end
end
