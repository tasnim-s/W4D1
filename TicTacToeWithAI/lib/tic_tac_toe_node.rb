require_relative 'tic_tac_toe'

class TicTacToeNode
  attr_accessor :board, :next_mover_mark, :prev_move_pos
  def initialize(board, next_mover_mark, prev_move_pos = nil)
    @board = board
    @next_mover_mark = next_mover_mark
    @prev_move_pos = prev_move_pos
  end

  def losing_node?(evaluator)
    return false if board.tied?
    return true if board.over? && evaluator != @board.winner
    return false if board.over? && (evaluator == @board.winner || @board.winner.nil?)

    children.none? {|child| child.losing_node?(evaluator)}
    children.any? {|child| child.losing_node?(evaluator)}
  end

  def winning_node?(evaluator)
    return false if board.over? && (evaluator != @board.winner || @board.winner.nil?)
    return true if board.over? && evaluator == @board.winner 

    children.any? {|child| child.winning_node?(evaluator)} || children.all? {|child| child.winning_node?(evaluator)}
  end

  # This method generates an array of all moves that can be made after
  # the current move.
  def children
    positions = []

    (0...board.rows.count).to_a.each do |row|
      (0...board.rows.count).to_a.each do |col|
        pos = [row, col]
        positions << pos if board.empty?(pos)
      end
    end

    children_array = []

    positions.each do |pos|
      duped = board.dup
      duped[pos] = next_mover_mark
      (next_mover_mark == :x) ? (next_mover_mark = :o) : (next_mover_mark = :x)
      child = TicTacToeNode.new(duped, next_mover_mark, pos)
      children_array << child
    end
    children_array
  end

end
