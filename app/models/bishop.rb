class Bishop < Piece
  def valid_move?(x, y)
    # can only move diagonally
    is_obstructed?(x, y)
    (x_position - x).abs == (y_position - y).abs
  end
end
