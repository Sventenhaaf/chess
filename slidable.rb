module Slidable
  HORIZONTAL_DIRS = [[0,1],[1,0],[-1,0],[0,-1]]
  DIAGONAL_DIRS = [[1,1],[1,-1],[-1,1],[-1,-1]]


  def hor_valid_moves
    moves(HORIZONTAL_DIRS)
  end

  def dia_valid_moves
    moves(DIAGONAL_DIRS)
  end

  def moves(directions)
    pos = position
    positions = []
    directions.each do |dir|
      positions.concat(explore_dir(dir))
    end
    return positions
  end

  def explore_dir(dir)
    added_pos = position
    opponent_hit = false
    pos_in_this_dir = []

    while true
      added_pos = [added_pos[0] + dir[0], added_pos[1] + dir[1]]
      break unless valid_move?(added_pos)
      pos_in_this_dir << added_pos
      if opponent_hit(added_pos)
        break
      end
    end

    pos_in_this_dir
  end

  def opponent_hit(position)
    piece = @board.grid[position[0]][position[1]]
    opponent_hit = true if piece.color != self.color && piece.color != :n
  end

  def valid_move?(pos)
    row = pos[0]
    col = pos[1]
    if row < 0 || row > 7 || col < 0 || col > 7
      return false
    elsif @board.grid[row][col].color == self.color
      return false
    end
    true
  end

end
