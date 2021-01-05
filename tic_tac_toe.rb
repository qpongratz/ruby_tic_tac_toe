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
  
  def initialize(piece)
    @piece = piece
    self.get_player_name
  end

  def get_player_name
    puts "What would the player of #{@piece}'s like to be called?"
    @player_name = gets.chomp
  end

  def get_move
    puts "#{@player_name}'s turn. On what space would you like a #{@piece}?"
    input = Helper.translate(gets.chomp)
    if input.nil? 
      puts "Invalid entry."
      self.get_move
    else
      puts "You did it!"
    end
  end
end

class Game
  attr_accessor(:board)
  
  def initialize
    @turn_count = 0
    self.board = Board.new
    @players = [(Player.new('X')), (Player.new('O'))]
    @players.shuffle!
    self.new_turn
  end

  def new_turn
    @turn_count += 1
    @players[@turn_count % 2].get_move
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
end

board = Board.new
board.display_board