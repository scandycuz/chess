require 'singleton'
require 'colorize'

class Piece
  attr_accessor :pos
  def initialize(color = nil, board, pos)
    @color = color
    @board = board
    @pos = pos
  end

  def get_moves
    moves(@move_dir, @pos)
  end

  def to_s
    @symbol
  end

end

module SlidingPiece
  def moves(dir ,pos)
    moves = []
    row, col = pos
    case dir
    when "horiz/vert"
      moves += horiz_vert_moves(pos)
    when "diag"
      moves += diag_moves(pos)
    when "both"
      moves += horiz_vert_moves(pos)
      moves += diag_moves(pos)
    end
    moves
  end

  def horiz_vert_moves(pos)
    moves = []
    row, col = pos
    (0..7).each do |idx|
      moves << [row, idx] unless col == idx
      moves << [idx, col] unless row == idx
    end
    moves
  end

  def diag_moves(pos)
    moves = []
    row, col = pos
    (1..7).each do |diff|
      moves << [row + diff, col + diff]
      moves << [row - diff, col - diff]
      moves << [row + diff, col - diff]
      moves << [row - diff, col + diff]
    end
    moves.select! do |coords|
      coords.all? { |coord| coord.between?(0,7) }
    end
    moves
  end
end

module SteppingPiece
  def moves(pos, diffs)
    moves = []
    row, col = pos
    moves << [row + diffs[0], col + diffs[1]]
    moves << [row + diffs[0], col - diffs[1]]
    moves << [row - diffs[0], col + diffs[1]]
    moves << [row - diffs[0], col - diffs[1]]
    case diffs
    when [1, 2]
      moves << [row + diffs[1], col + diffs[0]]
      moves << [row + diffs[1], col - diffs[0]]
      moves << [row - diffs[1], col + diffs[0]]
      moves << [row - diffs[1], col - diffs[0]]
    when [1, 1]
      moves << [row, col + diffs[1]]
      moves << [row, col - diffs[1]]
      moves << [row + diffs[0], col]
      moves << [row - diffs[0], col]
    end
    moves
  end
end

class Rook < Piece
  include SlidingPiece
  def initialize(color = nil, board, pos)
    @move_dir = "horiz/vert"
    @pos = pos
    case color
    when :white
      @symbol = "\u2656".encode('utf-8')
    when :black
      @symbol = "\u265C".encode('utf-8').colorize(:yellow)
    end
    super(color = nil, board, pos)
  end
end

class Bishop < Piece
  include SlidingPiece
  def initialize(color = nil, board, pos)
    @move_dir = "diag"
    @pos = pos
    case color
    when :white
      @symbol = "\u2657".encode('utf-8')
    when :black
      @symbol = "\u265D".encode('utf-8').colorize(:yellow)
    end
    super(color = nil, board, pos)
  end
end

class Queen < Piece
  include SlidingPiece
  def initialize(color = nil, board, pos)
    @move_dir = "both"
    @pos = pos
    case color
    when :white
      @symbol = "\u2655".encode('utf-8')
    when :black
      @symbol = "\u265B".encode('utf-8').colorize(:yellow)
    end
    super(color = nil, board, pos)
  end
end

class Knight < Piece
  include SteppingPiece
  def initialize(color = nil, board, pos)
    @pos = pos
    case color
    when :white
      @symbol = "\u2658".encode('utf-8')
    when :black
      @symbol = "\u265E".encode('utf-8').colorize(:yellow)
    end
    super(color = nil, board, pos)
  end
end

class King < Piece
  include SteppingPiece
  def initialize(color = nil, board, pos)
    @pos = pos
    case color
    when :white
      @symbol = "\u2654".encode('utf-8')
    when :black
      @symbol = "\u265A".encode('utf-8').colorize(:yellow)
    end
    super(color = nil, board, pos)
  end
end

class Pawn < Piece
  include SteppingPiece
  def initialize(color = nil, board, pos)
    @pos = pos
    case color
    when :white
      @symbol = "\u2659".encode('utf-8')
    when :black
      @symbol = "\u265F".encode('utf-8').colorize(:yellow)
    end
    super(color = nil, board, pos)
  end
end

class NullPiece
  include Singleton

  def initialize(color = nil)
    @moves = nil
    @color = color
  end

  def to_s

  end

  def empty?

  end
end
