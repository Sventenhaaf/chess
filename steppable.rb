module Steppable
  KING_DIRS = [[0,1],[1,0],[-1,0],[0,-1],[1,1],[1,-1],[-1,1],[-1,-1]]
  KNIGHT_DIRS = [[2,1],[1,2],[-1,2],[2,-1],[-2,1],[-2,-1],[-1,-2],[1,-2]]

  def king_valid_moves
    moves(KING_DIRS)
  end

  def knight_valid_moves
    moves(KNIGHT_DIRS)
  end

  def moves(directions)
    positions = []
    directions.each do |dir|
      new_pos = [(position[0] + dir[0]), (position[1] + dir[1])]
      positions << new_pos if valid_move?(new_pos)
    end
    return positions
  end

  def valid_move?(pos)
    row = pos[0]
    col = pos[1]
    if !board.in_bound?(pos)
      return false
    elsif @board.grid[row][col].color == self.color
      return false
    end
    true
  end
end
