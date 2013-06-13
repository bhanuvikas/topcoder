class ArcadeManao

  def initialize level, coin_row, coin_column
    @level = level.map do |r|
      # @level is an array of arrays of booleans
      r.chars.map { |c| c == 'X' }
    end
    @coin_row = coin_row
    @coin_column = coin_column
    # make the spot with the coin accessible (a "platform")
    @level[@coin_row-1][@coin_column-1] = true
    #print_level
    @paths = []
    @moves_queue = []
  end

  def shortest_ladder
    # manao starts at the bottom row
    @moves_queue << [@level.size-1, 0, Path.new]
    explore_moves
    @paths.collect { |path| path.longest_ladder_used }.min
  end

  def explore_moves # row, column, path

    move = @moves_queue.pop
    row = move[0]
    column = move[1]
    path = move[2]
    #print_level path.last_explored

    path.explore row, column
    if path.ends_on? @coin_row-1, @coin_column-1
      @paths.unshift Path.new(path.explored_positions.clone)
    else
      # add 3 (possible) moves to the stack:
      # move 1 to the left
      left = [(column-1), 0].max
      if @level[row][left] and path.is_not_yet_explored?(row, left)
        @moves_queue.unshift [row, left, Path.new(path.explored_positions.clone)]
      end
      # move 1 to the right
      right = [(column+1), @level[row].size-1].min
      if @level[row][right] and path.is_not_yet_explored?(row, right)
        @moves_queue.unshift [row, right, Path.new(path.explored_positions.clone)]
      end
      # see if we can go up/down the ladder here
      count = 0
      until count == @level.size
        count += 1
        # go up/down by count, see if theres a platform
        [count, count * -1].each do |c|
          if row - c >= 0
            new_row = @level[row - c]
            if new_row
              new_spot = new_row[column]
              if new_spot
                @moves_queue.unshift [row - c, column, Path.new(path.explored_positions.clone)] if path.is_not_yet_explored?(row - c, column)
              end
            end
          end
        end
      end
    end

    explore_moves unless @moves_queue.empty?

  end


  # for debug
  def print_level manao=nil
    @level.each_with_index do |r, x|
      r.each_with_index do |c, y|
        if x+1 == @coin_row and y+1 == @coin_column
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
    puts manao.inspect if manao
    puts "=========="
  end

end

class Path

  attr_reader :explored_positions

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

  def ends_on? row, column
    @explored_positions.last == [row, column]
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

  # for debug
  def to_s
    @explored_positions.inspect
  end

  def last_explored
    @explored_positions.last
  end

end

level1 = ["XXXX....", "...X.XXX", "XXX..X..", "......X.", "XXXXXXXX"]
level2 = ["XXXX", "...X", "XXXX"]
level3 = ["..X..", ".X.X.", "X...X", ".X.X.", "..X..", "XXXXX"]
level4 = ["X"]
level5 = ["XXXXXXXXXX", "...X......", "XXX.......", "X.....XXXX", "..XXXXX..X", ".........X", ".........X", "XXXXXXXXXX"]
puts ArcadeManao.new(level1, 2, 4).shortest_ladder
puts ArcadeManao.new(level2, 1, 1).shortest_ladder
puts ArcadeManao.new(level3, 1, 3).shortest_ladder
puts ArcadeManao.new(level4, 1, 1).shortest_ladder
puts ArcadeManao.new(level5, 1, 1).shortest_ladder
