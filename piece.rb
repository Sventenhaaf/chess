class Piece
  attr_accessor :position
  attr_reader :color, :board

  def initialize(color, board, position)
    @color = color
    @board = board
    @position = position
  end

  def empty?
    false
  end

  def valid_moves
    self.possible_moves.reject do |move|
      duped_board = board.deep_dup
      duped_board.move_piece!(@position, move)
      duped_board.in_check?(@color)
    end
  end

  def dup(duped_board)
    self.class.new(self.color, duped_board, self.position.dup)
  end
end
