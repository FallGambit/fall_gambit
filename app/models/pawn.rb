class Pawn < Piece
  def valid_move?(x, y)
    is_obstructed?(x, y)
    one_forward(x, y) || two_forward(x, y) || one_diagonal(x, y)
  end

  def white_moving
    color
  end

  def one_forward(x, y)
    if white_moving
      x == x_position && y == y_position + 1
    else
      x == x_position && y == y_position - 1
    end
  end

  def two_forward(x, y)
    if white_moving
      y_position == 1 && x == x_position && y == y_position + 2
    else
      y_position == 6 && x == x_position && y == y_position - 2
    end
  end

  def one_diagonal(x, y)
    unless game.pieces.where(:x_position => x, :y_position => y).nil?
      if white_moving
        y == y_position + 1 && (x == x_position + 1 || x == x_position - 1)
      else
        y == y_position - 1 && (x == x_position + 1 || x == x_position - 1)
      end
    end
  end
end
