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

    positions
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
    piece.color != self.color && piece.color != :n
  end

  def valid_move?(pos)
    board.in_bound?(pos) && @board[pos].color != color
  end
end
