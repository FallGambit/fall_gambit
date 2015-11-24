class King < Piece
  def valid_move?(x, y)
    rows = (y - y_position).abs
    columns = (x - x_position).abs
    rows <= 1 && columns <= 1 ? true : false
  end
end
