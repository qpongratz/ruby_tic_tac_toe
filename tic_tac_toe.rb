require 'pry'

module Helper
  COORDINATE_MAP = ['a1', 'a2', 'a3', 'b1', 'b2', 'b3', 'c1', 'c2', 'c3']
  
  def self.translate(coordinates)
    index = COORDINATE_MAP.index(coordinates.downcase)
    if index.nil?
      index = COORDINATE_MAP.index(coordinates.reverse.downcase)
    end
    index
  end

end

class Player
  include Helper
  
  def initialize(piece, board)
    @piece = piece
    @board = board
    self.get_player_name
  end

  def get_player_name
    puts "What would the player of #{@piece}'s like to be called?"
    @player_name = gets.chomp
  end

  def get_move
    puts "#{@player_name}'s turn. On what space would you like a #{@piece}?"
    input = Helper.translate(gets.chomp)
    if input.nil? || @board.invalid_move?(input)
      puts "Invalid entry."
      @board.display_board
      self.get_move
    else
      @board.update_board(input, @piece)
    end
  end

  def declare_winner
    puts "Congratulations, #{@player_name}! You have won!"
  end
end

class Game
  attr_accessor :board, :players
  
  def initialize
    @@turn_count = 0
    self.board = Board.new
    @@players = [(Player.new('X', self.board)), (Player.new('O', self.board))]
    @@players.shuffle!
    self.board.display_board
    Game.new_turn
  end

  def self.new_turn
    @@turn_count += 1
    if @@turn_count > 9
      self.tie_game
    else
      @@players[@@turn_count % 2].get_move
    end
  end

  def self.end_game
    @@players[@@turn_count % 2].declare_winner
    "Thank you for playing. Come again soon."
  end

  def self.tie_game
    puts "Tie game; no winners."
  end
end

class Board
  
  def initialize
    @board_state = Array.new(9)
  end

  def display_board 
    display = @board_state.map {|spot| spot.nil? ? spot = ' ' : spot}
    puts "  1 2 3"
    puts "a #{display[0]}│#{display[1]}│#{display[2]}"
    puts "  ─┼─┼─"
    puts "b #{display[3]}│#{display[4]}│#{display[5]}"
    puts "  ─┼─┼─"
    puts "c #{display[6]}│#{display[7]}│#{display[8]}"    
  end

  def invalid_move?(index)
    @board_state[index].nil? ? false : true
  end

  def update_board(index, piece)
    @board_state[index] = piece
    self.display_board
    self.check_win(piece)
  end

  def check_win(piece)
    if ([@board_state[0], @board_state[1], @board_state[2]].all?(piece) ||
      [@board_state[3], @board_state[4], @board_state[5]].all?(piece) ||
      [@board_state[6], @board_state[7], @board_state[8]].all?(piece) ||
      [@board_state[0], @board_state[3], @board_state[6]].all?(piece) ||
      [@board_state[1], @board_state[4], @board_state[7]].all?(piece) ||
      [@board_state[2], @board_state[5], @board_state[8]].all?(piece) ||
      [@board_state[0], @board_state[4], @board_state[8]].all?(piece) ||
      [@board_state[2], @board_state[4], @board_state[6]].all?(piece))
        Game.end_game
    else
      Game.new_turn
    end  
  end
end

new_game = Game.new
