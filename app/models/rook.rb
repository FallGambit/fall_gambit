class Rook < Piece
  def valid_move?(x, y)
    # straight up/dn side/side
    x == x_position || y == y_position
  end
end
