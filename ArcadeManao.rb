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
    @ladder_length = 0
    # print_level
  end

  def shortest_ladder
    search_until_best_path_is_found!
    @ladder_length
  end

  private

  def search_until_best_path_is_found!
    (0..@level.size).each do |limit|
      @ladder_length = limit
      # manao starts at the coin and works his way to the bottom
      @moves_queue << [@coin_row, @coin_column, Path.new]
      explore_moves(limit) until @moves_queue.empty?
      break unless @paths.empty?
    end
  end

  def explore_moves ladder_length_limit
    row, column, path = @moves_queue.pop
    # print_level path.last
    path.explore row, column
    if path.ends_on_row? @level.size-1
      @paths << path
    else
      # add all possible moves to the stack:
      try_move row, column - 1, path # move 1 to the left
      try_move row, column + 1, path # move 1 to the right
      # see if we can go up/down the ladder. try all lengths within the limit.
      (0..ladder_length_limit).each do |len|
        try_move row + len, column, path
        try_move row - len, column, path
      end
    end
  end

  # check move for sanity, then allow/disallow it and return true/false
  def try_move row, column, path
    if row >= 0 and row < @level.size and
      column >= 0 and column < @level.last.size and
      @level[row] and @level[row][column] and
      path.is_not_yet_explored?(row, column)
      @moves_queue << [row, column, path]
    end
  end

end


class Path

  attr_reader :explored_positions
  extend Forwardable
  def_delegators :@explored_positions, :[], :size, :reverse, :to_s, :last

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
level6 = ["XX.........XXXXXX", ".X.X..X.XXXXX..XX", "X..X.X..X.X.X..XX", ".X.XXXXX.........", ".X.XX.X.X.X.XX.XX", "X.X.XXXX.X.XX....", "XXX..XXX.XXX.X.X.", "XXX.XXXX..XX.X...", "....X.X...XX.XXXX", "X..X.X..XX...X...", "XXXXX.X....XX.XXX", "XXXXXX.XXX..XXXX.", "..X.X..X..X.X..X.", "...XXXXX..XX...X.", ".XXXXX..X.XXXXX..", "X..X..X..XX.XX..X", "XX.X.X...XXX..X..", "..XX....X.X..X.XX", "XXXX.....X.X.XX..", ".X.XXX...XX.XXXX.", "..XX.XXX....X.XXX", "XXXXXXXXXXXXXXXXX"]
level7 = ["XXX..XXXX.XX.X.X", "XX....XX.XXX...X", ".X.....XXXX..XXX", ".......X..X.X.XX", "..X...X..X..X...", "XXXX.XXX....X.X.", ".XXXXXXXX..X.XX.", "......XXX.....X.", "..XX.XXXX..XXXXX", "..XX...XX..X.X.X", "XX.X.X...XXXX.X.", "...XXX...X.X.X.X", "..X.X.X.X.X.....", "XXXX.XX..X...XXX", "XX.X.X..XXX..XXX", ".XX..X.XX.X..XXX", ".XXX.....XXX.X.X", "X.XX..X...X.XX.X", "XXX.....XXXX.XXX", "XXXXXX.X....X..X", ".X.X...X.XX...X.", "..XX.XXX..XXX...", ".XXX.XXX..X....X", "...X.XXX.X.X....", "XXXX..XX.XX..X..", ".X.XX...X.XX..XX", "XXX...XX..X.XXXX", ".X.XX...X.XX..X.", "..XXX.XXX.XXX..X", "..XXX..X.....XXX", ".......XXXXX..XX", "XX..X.X..X..XXX.", "..X.XXXXXXX.XXXX", "..XX.XX..XXXXXX.", "XX.XXX.X.XX.X...", ".XX.X..X.X...XXX", ".X...XXXXXX.....", "XXX..X...XXXX.X.", "X.X.XX.X.XXXX...", "..XXX.XXXX.X..XX", ".X.X...XXXXX.XX.", "XX.XXXX..X.X....", "..XX..XX.XX.X..X", ".XX.X..XX.XX.XX.", ".....X.X.X...XXX", "XX........XX...X", ".XXX..XXXX...XX.", "..XX..........X.", "XXXXXXXXXXXXXXXX"]
level8 = ["X.XXX.XX.X..XX..XXXXXXXX.X.X", "XX........XXXX..X..XXX...XX.", "X.XX.XXXX.XX.X.X....XXXX....", "..X.X..XX...XX......X.X....X", "..XXX.XXXX.XX.X.X.X.X..XX..X", "..XXXX..XX....XXX.XX.XX...XX", "..XX..XXXX..XXXX...XX...X...", "....X......X...X.X..XXXXXXXX", ".....X.XXX........X......X..", ".XX..X..X.XXXXXXXXX.X..X..XX", "XXX..X..X.XXX..XXXX...XXX...", ".XXX...XXX..XXX....XX.X..X.X", "...XXX.....XX..XXX.X..XX...X", ".XXX...XX..X...X..X..XX..XX.", ".X..X....X..XXXX.XX..XX.X..X", "XX..XXXX.X.XX.X..XXX........", "....X.X..XX...X.XXXX..XXX.XX", "XXX....XX.XXXX..X..X...XX.XX", "..X...X..XXXXXXX.XXXXX.X.XXX", ".X.X..XX.X......X.XX.X.X.X.X", "XXX...X......X...X...X.X..X.", ".X..XX.X.X.XXXXXX..X.X.X....", "XX.X..X...X..X..XX.......XXX", ".XXXX..X..X.XXX.X..XX..X.XXX", "X......XXXXX.XXX.XX.X.X.X...", "XX..X....X..XXX...X..X.XXX.X", ".X.XX..X.XX....X.X...XXX..X.", "XXX.XX....X...X.XXXXXXX....X", "XX....XX.XX..X..X.X.....XX..", "XXX..XX..XX.X.XX...X.XXXX.X.", "XX.XXXXX.X.XX..X...X.X..XXX.", "...XX...XX..XX..X......XXXXX", "XXX.X...X.XX.X..XXXXXX...XXX", "..X..X....XX......XX.X.X.XX.", "..XX.X.XXX....X...X.X....XXX", "XXXXX.X.X..X.X.XX.XXX.X...X.", "XXX.XXX.XX...XX..X...XX...X.", ".XXXX..X...XX..X.X..XX.X.X..", ".XX......X..X.XX..X..X..XX..", ".X.XXX.XX....XX.....X.X.X...", "X...XX.X...X.....X.XX.X.X.X.", "..X.XX......XXXX...X..XX..X.", "..X...X.X.XX..XX..X...X.XXX.", ".X.X..XX..XXXX.XX.....XXX.X.", ".XX.X.XXX....XXXX.....XX....", "..XX..X.XX..X.......X...XXXX", "X.XXX....X..X..X.XXX.XX..X..", ".X..X.XX...XX..XXX.X...XXXX.", "XXXXXXXXXXXXXXXXXXXXXXXXXXXX"]
level9 = ["....X..X.....XX...........X...XX......X.X....", "....X.....XX......X.......X.................X", "....................................X........", "X.X.......X.........XX..X.X.......X..X.......", ".........X...X.X....X..........X.X...........", "........X..................X.................", "..X........X.....X.....................XX...X", "...XX....X..........X............X........X..", "....X...XX...X.......X.......X...X....XX.X.X.", ".X...X......X.X.X.X.......X...X.X..X...XX....", ".X......X..X.........XX....X........X.....X..", "........X....................................", "X..X................X.X.....X..X..X........X.", ".............X........................XXX....", "........X.......X....X.X..X....XX............", "....X................XX......X...XX..X..X....", "..................X...X...X.X........X....XX.", "...........XX...........X....X...XX.........X", ".....X............................X.X..X...X.", "....XX..X.........X..............X...........", "................X........X....X..X....X......", "..X....XXX...XX...X....X...XX....X..X........", "X..........X...X.......X.X......X......X.X...", ".X..XX..........X....X......XX......X.X......", "........X.....................X..............", "...X.......X........X...........X.....XX....X", "..........X......X..X...X....................", "..........XX..XX..X.X.X........XX............", "...X....X...X..X..X...X....X........X.....X..", "......................X..........X....X.XX...", "....X......X..X.X....X.X.......X......X......", "X.....X......XX.........X.X....X.............", ".X....X...X...........X...X.X.............X..", ".........XX...XX....X.......................X", "......X........X.....X...X.X............X....", ".X..........X...X......X.......X.X....X..X...", "...........................X..............X..", ".X........................XX.....X..........X", "...X......X........X.............X.....X...X.", "XX...................X.....X..........X.X....", "X.......XX.....X..X..................X.X...X.", ".....X......X......X..X.......X..X........X.X", "....X...........X....X..X....X.X.........X..X", "..X......X...........................X......X", ".........X...X....X..X.X....X.....X....X.X.XX", "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"]

puts ArcadeManao.new(level1, 2, 4).shortest_ladder
puts ArcadeManao.new(level2, 1, 1).shortest_ladder
puts ArcadeManao.new(level3, 1, 3).shortest_ladder
puts ArcadeManao.new(level4, 1, 1).shortest_ladder
puts ArcadeManao.new(level5, 1, 1).shortest_ladder
puts ArcadeManao.new(level6, 17, 4).shortest_ladder
puts ArcadeManao.new(level7, 44, 11).shortest_ladder
puts ArcadeManao.new(level8, 41, 12).shortest_ladder
puts ArcadeManao.new(level9, 43, 45).shortest_ladder
