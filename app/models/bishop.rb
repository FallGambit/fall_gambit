class Bishop < Piece
  def is_obstructed?
    # diag only
  end

  def valid_move?(x, y)
    # can only move diagonally
    (x_position - x).abs == (y_position - y).abs
  end
end
