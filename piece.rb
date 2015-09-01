require_relative 'board.rb'
require_relative 'slidable'
require_relative 'steppable'
require_relative 'pawnable'

class Piece
  attr_accessor :position
  attr_reader :color, :board

  def initialize(color, board, position)
    @color = color
    @board = board
    @position = position
  end

  def present?
    true
  end

  def to_s
    " x "
  end

  def valid_moves
    # Each possible moves
      # duped board
      # select !(in check)
    # end

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

class NullPiece
  attr_reader :color

  def present?
    false
  end

  def initialize
    @color = :n
  end

  def dup(duped_board)
    NullPiece.new
  end

  def to_s
    "   "
  end
end

class Pawn < Piece
  attr_reader :dir, :first_move

  def initialize(color, board, position)
    super(color, board, position)
    @first_move = true
    color == :w ? @dir = 1 : @dir = -1
  end

  def possible_moves
    moves = []
    moves.concat(kill_moves)
    moves.concat(peaceful_moves)
    moves.select { |move| board.in_bound?(move) }
  end

  def kill_moves
    result = []
    [-1, 1].each do |i|
      check_pos = [position[0] + @dir, position[1] + i]
      next unless board.in_bound?(check_pos)
      result << check_pos if board[check_pos].color != @color && !board.empty?(check_pos)
    end
    result
  end

  def peaceful_moves
    result = []
    @first_move ? diffs = [1, 2] : diffs = [1]
    diffs.each do |i|
      check_pos = [position[0] + (i * @dir), position[1]]
      next unless board.in_bound?(check_pos)
      if board.empty?(check_pos)
        result << check_pos
      else
        break
      end
    end
    result
  end

  def to_s
    color == :w ? " \u2659 " : " \u265F "
  end
end

class Castle < Piece
  include Slidable

  def possible_moves
    hor_valid_moves
  end

  def to_s
    color == :w ? " \u2656 " : " \u265C "
  end
end

class Bishop < Piece
  include Slidable

  def possible_moves
    dia_valid_moves
  end

  def to_s
    color == :w ? " \u2657 " : " \u265D "
  end
end

class Queen < Piece
  include Slidable


  def possible_moves
    dia_valid_moves + hor_valid_moves

  end

  def to_s
    color == :w ? " \u2655 " : " \u265B "
  end
end

class King < Piece
  include Steppable

  def possible_moves
    king_valid_moves
  end

  def to_s
    color == :w ? " \u2654 " : " \u265A "
  end
end

class Knight < Piece
  include Steppable

  def possible_moves
    knight_valid_moves
  end

  def to_s
    color == :w ? " \u2658 " : " \u265E "
  end
end
