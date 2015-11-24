class King < Piece
  def valid_move?(x, y)
    rows = y - y_position
    columns = x - x_position
    rows <= 1 && columns <= 1 ? true : false
  end
end
