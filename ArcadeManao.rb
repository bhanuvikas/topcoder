require 'forwardable'

class ArcadeManao

  def initialize level, coin_row, coin_column
    @level = level.map do |r|
      # @level is an array of arrays of booleans
      r.chars.map { |c| c == 'X' }
    end
    @coin_row = coin_row - 1
    @coin_column = coin_column - 1
    @level[@coin_row][@coin_column] = true
    @paths = []
    @moves_queue = []
    #print_level
  end

  def shortest_ladder
    # manao starts at the coin and works his way to the bottom
    @moves_queue << [@coin_row, @coin_column, Path.new]
    explore_moves until @moves_queue.empty?
    @paths.collect { |path| path.longest_ladder_used }.min
  end

  def best_path
    # returns the shortest path found using the shortest ladder possible
    @moves_queue << [@coin_row, @coin_column, Path.new]
    explore_moves until @moves_queue.empty?
    paths = @paths.group_by { |path| path.longest_ladder_used }
    bests = paths[paths.keys.sort.first]
    bests.sort_by { |p| p.size }.first
  end

  def explore_moves
    row, column, path = @moves_queue.pop
    # print_level path.last
    path.explore row, column
    if path.ends_on_row? @level.size-1
      @paths << Path.clone(path)
    else
      # add all possible moves to the stack:
      try_move row, column - 1, path # move 1 to the left
      try_move row, column + 1, path # move 1 to the right
      # see if we can go up/down the ladder. try the shortest move up/down.
      up = down = false
      @level.size.times do |count|
        unless up && down
          [count, count * -1].each do |c|
            if c > 0 && !down
              down = try_move row - c, column, path
            elsif !up
              up = try_move row - c, column, path
            end
          end
        end
      end
    end
  end

  # check move for sanity, then allow/disallow it and return true/false
  def try_move row, column, path
    if check = (row >= 0 and row < @level.size and
      column >= 0 and column < @level.last.size and
      @level[row] and @level[row][column] and
      path.is_not_yet_explored?(row, column))
      @moves_queue << [row, column, Path.clone(path)]
    end
    check
  end

end

class Path

  attr_reader :explored_positions
  extend Forwardable
  def_delegators :@explored_positions, :[], :size, :reverse, :to_s, :last

  def self.clone path
    self.new path.explored_positions.clone
  end

  def initialize positions=[]
    # explored positions is an array of arrays [[r,c],[r,c],...]
    @explored_positions = positions
  end

  def is_not_yet_explored? row, column
    pos = [row, column]
    @explored_positions.none? { |p| p == pos }
  end

  def explore row, column
    @explored_positions << [row, column]
  end

  def ends_on_row? row
    @explored_positions.last[0] == row
  end

  def longest_ladder_used
    longest = 0
    @explored_positions.each_with_index do |p, i|
      nxt = @explored_positions[i+1]
      if nxt
        length = (nxt[0] - p[0]).abs
        longest = length if length > longest
      end
    end
    longest
  end

end

class ArcadeManao
  def print_level manao=nil
    @level.each_with_index do |r, x|
      r.each_with_index do |c, y|
        if x == @coin_row and y == @coin_column
          if manao && manao[0] == x && manao[1] == y
            print "$"
          else
            print "0"
          end
        elsif manao && x == manao[0] && y == manao[1]
          if c
            print "M"
          else
            print "?"
          end
        elsif c
          print "_"
        else
          print " "
        end
      end
      print "\n"
    end
    puts "\n" * 2
  end
end

level1 = ["XXXX....", "...X.XXX", "XXX..X..", "......X.", "XXXXXXXX"]
level2 = ["XXXX", "...X", "XXXX"]
level3 = ["..X..", ".X.X.", "X...X", ".X.X.", "..X..", "XXXXX"]
level4 = ["X"]
level5 = ["XXXXXXXXXX", "...X......", "XXX.......", "X.....XXXX", "..XXXXX..X", ".........X", ".........X", "XXXXXXXXXX"]

puts ArcadeManao.new(level1, 2, 4).shortest_ladder
puts ArcadeManao.new(level1, 2, 4).best_path.inspect

puts ArcadeManao.new(level2, 1, 1).shortest_ladder
puts ArcadeManao.new(level2, 1, 1).best_path.inspect

puts ArcadeManao.new(level3, 1, 3).shortest_ladder
puts ArcadeManao.new(level3, 1, 3).best_path.inspect

puts ArcadeManao.new(level4, 1, 1).shortest_ladder
puts ArcadeManao.new(level4, 1, 1).best_path.inspect

puts ArcadeManao.new(level5, 1, 1).shortest_ladder
puts ArcadeManao.new(level5, 1, 1).best_path.inspect
