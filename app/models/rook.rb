class Rook < Piece
  def valid_move?(x, y)
    is_obstructed?(x, y)
    x == x_position || y == y_position
  end
end
