# frozen_string_literal: true

# Stores coordinate map and converts coordinates to array index for board class.
module Helper
  COORDINATE_MAP = %w[a1 a2 a3 b1 b2 b3 c1 c2 c3].freeze

  def translate(coordinates)
    index = COORDINATE_MAP.index(coordinates.downcase)
    index = COORDINATE_MAP.index(coordinates.reverse.downcase) if index.nil?
    index
  end
end

# Handles player names and inputs for moves.
class Player
  include Helper
  attr_reader :piece, :player_name

  def initialize(piece)
    @piece = piece
  end

  def set_player_name
    puts "What would the player of #{piece}'s like to be called?"
    @player_name = input
  end

  def play_move(board)
    move = obtain_move
    if move.nil? || board.invalid_move?(move)
      puts 'Invalid entry.'
      board.display_board
      play_move(board)
    else
      board.update_board(move, piece)
    end
  end

  def obtain_move
    puts "#{player_name}'s turn. On what space would you like a #{piece}?"
    puts 'Your input should be two characters long indicating row and column.'
    translate(input)
  end

  def input
    gets.chomp
  end

  def declare_winner
    puts "Congratulations, #{player_name}! You have won!"
  end
end

# Initializes other classes and delegates turns and manages end states.
class Game
  attr_accessor :board, :players, :turn_count

  def initialize
    @turn_count = 0
    @board = Board.new
    @players = [Player.new('X'), Player.new('O')]
  end

  def start
    players.each(&:set_player_name)
    players.shuffle!
    board.display_board
    new_turn
  end

  def new_turn
    while turn_count < 9
      current_player = players[turn_count % 2]
      current_player.play_move(board)
      return end_game if board.check_win(current_player.piece)

      @turn_count += 1
    end
    tie
  end

  def end_game
    players[@turn_count % 2].declare_winner
    'Thank you for playing. Come again soon.'
  end

  def tie
    puts 'Tie game; no winners.'
  end
end

# Displays and stores board array and checks if win condition has been met.
class Board
  attr_reader :board_state

  def initialize
    @board_state = Array.new(9)
  end

  def display_board
    display = board_state.map { |spot| spot.nil? ? ' ' : spot }
    puts <<-HEREDOC
      1 2 3
    a #{display[0]}│#{display[1]}│#{display[2]}
      ─┼─┼─
    b #{display[3]}│#{display[4]}│#{display[5]}
      ─┼─┼─
    c #{display[6]}│#{display[7]}│#{display[8]}
    HEREDOC
  end

  def invalid_move?(index)
    board_state[index].nil? ? false : true
  end

  def update_board(index, piece)
    board_state[index] = piece
    display_board
  end

  def check_win(piece)
    bs = board_state
    [bs[0], bs[1], bs[2]].all?(piece)   ||
      [bs[3], bs[4], bs[5]].all?(piece) ||
      [bs[6], bs[7], bs[8]].all?(piece) ||
      [bs[0], bs[3], bs[6]].all?(piece) ||
      [bs[1], bs[4], bs[7]].all?(piece) ||
      [bs[2], bs[5], bs[8]].all?(piece) ||
      [bs[0], bs[4], bs[8]].all?(piece) ||
      [bs[2], bs[4], bs[6]].all?(piece)
  end
end
