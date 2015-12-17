class King < Piece
  def valid_move?(dest_x, dest_y)
    rows = (dest_y - y_position).abs
    columns = (dest_x - x_position).abs
    dest_piece = game.pieces
                 .where("x_position = ? AND y_position = ?", dest_x, dest_y)
                 .take
    return false if dest_x < 0 || dest_x > 7 || dest_y < 0 || dest_y > 7
    return false if dest_piece && dest_piece.color == color
    rows <= 1 && columns <= 1 ? true : false
  end
end
