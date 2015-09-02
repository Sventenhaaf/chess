require_relative "player"
require_relative "board"
# require_relative './pieces/pieces'

class Game
  attr_reader :board

  def initialize
    @board = Board.new
    @player1 = Player.new(@board, :white)
    @player2 = Player.new(@board, :black)
    @current_player = @player1
  end

  def run
    puts "WASD or arrow keys to move the cursor, enter or space to confirm."
    until board.checkmate?(:white) || board.checkmate?(:black)

      play_turn

    end

    declare_winner
  end

  private

  def get_move
    puts "Where would you like to move?"
    from_pos = @current_player.move
    to_pos = @current_player.move
    if @board[from_pos].color != @current_player.color
      raise MoveError, "Only allowed to play your own color"
    end
    board.move_piece(from_pos, to_pos)
  end

  def declare_winner
    if @current_player.color == :white
      puts "Checkmate! Black wins!"
    else
      puts "Checkmate! White wins!"
    end
  end

  def play_turn
    begin
      get_move
    rescue MoveError
      puts "Invalid move! Try again"
      sleep(2)
      retry
    end
    switch_players!
  end

  def switch_players!
    if @current_player == @player1
      @current_player = @player2
    else
      @current_player = @player1
    end
  end

end

if __FILE__ == $PROGRAM_NAME
  Game.new.run
end
