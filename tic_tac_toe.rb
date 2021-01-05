# frozen_string_literal: true

# Stores coordinate map and converts coordinates to array index for board class.
module Helper
  COORDINATE_MAP = %w[a1 a2 a3 b1 b2 b3 c1 c2 c3].freeze

  def self.translate(coordinates)
    index = COORDINATE_MAP.index(coordinates.downcase)
    index = COORDINATE_MAP.index(coordinates.reverse.downcase) if index.nil?
    index
  end
end

# Handles player names and inputs for moves.
class Player
  include Helper
  attr_accessor :board

  def initialize(piece)
    @piece = piece
    set_player_name
  end

  def set_player_name
    puts "What would the player of #{@piece}'s like to be called?"
    @player_name = gets.chomp
  end

  def play_move
    puts "#{@player_name}'s turn. On what space would you like a #{@piece}?"
    puts 'Your input should be two characters long indicating row and column.'
    input = Helper.translate(gets.chomp)
    if input.nil? || board.invalid_move?(input)
      puts 'Invalid entry.'
      board.display_board
      play_move
    else
      board.update_board(input, @piece)
    end
  end

  def declare_winner
    puts "Congratulations, #{@player_name}! You have won!"
  end
end

# Initializes other classes and delegates turns and manages end states.
class Game
  attr_accessor :board, :players

  def initialize
    @turn_count = 0
    self.board = Board.new
    board.game = self
    @players = [Player.new('X'), Player.new('O')]
    @players.each { |player| player.board = board }
    @players.shuffle!
    board.display_board
    new_turn
  end

  def new_turn
    @turn_count += 1
    if @turn_count > 9
      tie_game
    else
      @players[@turn_count % 2].play_move
    end
  end

  def end_game
    @players[@turn_count % 2].declare_winner
    'Thank you for playing. Come again soon.'
  end

  def tie_game
    puts 'Tie game; no winners.'
  end
end

# Displays and stores board array and checks if win condition has been met.
class Board
  attr_accessor :game

  def initialize
    @board_state = Array.new(9)
  end

  def display_board
    display = @board_state.map { |spot| spot.nil? ? ' ' : spot }
    puts '  1 2 3'
    puts "a #{display[0]}│#{display[1]}│#{display[2]}"
    puts '  ─┼─┼─'
    puts "b #{display[3]}│#{display[4]}│#{display[5]}"
    puts '  ─┼─┼─'
    puts "c #{display[6]}│#{display[7]}│#{display[8]}"
  end

  def invalid_move?(index)
    @board_state[index].nil? ? false : true
  end

  def update_board(index, piece)
    @board_state[index] = piece
    display_board
    check_win(piece)
  end

  def check_win(piece)
    if [@board_state[0], @board_state[1], @board_state[2]].all?(piece) ||
       [@board_state[3], @board_state[4], @board_state[5]].all?(piece) ||
       [@board_state[6], @board_state[7], @board_state[8]].all?(piece) ||
       [@board_state[0], @board_state[3], @board_state[6]].all?(piece) ||
       [@board_state[1], @board_state[4], @board_state[7]].all?(piece) ||
       [@board_state[2], @board_state[5], @board_state[8]].all?(piece) ||
       [@board_state[0], @board_state[4], @board_state[8]].all?(piece) ||
       [@board_state[2], @board_state[4], @board_state[6]].all?(piece)
      game.end_game
    else
      game.new_turn
    end
  end
end

Game.new
