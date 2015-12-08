class Pawn < Piece
  def valid_move?(x, y)
    is_obstructed?(x, y)
    if white_moving?

    else
      # black_moving
    end
  end
  # def first_move
  #   # can move two spaces forward but only on first move
  # end
  #
  # def move
  # end
  def white_moving?
    color
  end
end


# First move, allowed to move 2
# All moves allowed to move 1
# Can’t capture vertically
# Up one, horizontal 1 to capture
# Don’t worry about en passant - we can worry about that later
