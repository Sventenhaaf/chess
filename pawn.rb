require_relative "piece"

class Pawn < Piece
  def initialize(color, board, position)
    super(color, board, position)
    @first_move = true
    color == :white ? @dir = 1 : @dir = -1
  end

  def possible_moves
    kill_moves + peaceful_moves
  end

  def to_s
    color == :white ? " \u2659 " : " \u265F "
  end

  private

  attr_reader :dir, :first_move

  def kill_moves
    result = []
    [-1, 1].each do |steps|
      new_pos = [position[0] + dir, position[1] + steps]
      next unless board.in_bound?(new_pos)
      result << new_pos if board[new_pos].color != @color && !board.empty?(new_pos)
    end
    result
  end

  def peaceful_moves
    result = []
    forward_steps = first_move ? [1, 2] : [1]

    forward_steps.each do |steps|
      new_pos = [position[0] + (steps * dir), position[1]]
      next unless board.in_bound?(new_pos)
      break unless board.empty?(new_pos)
      result << new_pos
    end

    result
  end
end
