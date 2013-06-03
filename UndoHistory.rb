class UndoHistory

  def initialize lines
    @given_lines = lines
    @results = []
    @buffer = ""
    @history = [] << ""
    @presses = 0
  end

  def min_presses
    @given_lines.each do |line|
      if !@buffer.empty? && line.chars.first(@buffer.size).join == @buffer
        # if the buffer already contains the beginning of the line
        # then just type out the rest of the line
        input_string line[@buffer.size..-1]
        enter
      else
        # otherwise, look for a good undo history item to use
        best = undo_best_matching_history_item line
        line = line[best.size..-1] if best
        undo "" unless @buffer.empty? or best
        input_string line
        enter
      end
    end
    puts "Results: #{@results}"
    @presses
  end

  private

  def input_string string
    string.chars.each { |char| input_letter char }
  end

  def undo_best_matching_history_item input
    match = @history.select { |item| input[0..item.size-1] == item }.sort_by(&:size).last
    undo match if match
    match
  end

  def input_letter letter
    @buffer += letter
    @history << @buffer
    @presses += 1
  end

  def enter
    @results << @buffer
    @presses += 1
  end

  def undo undo_string
    @buffer = undo_string
    @presses += 2
  end

end

puts UndoHistory.new(%w{tomorrow topcoder}).min_presses
puts UndoHistory.new(%w{a b}).min_presses
puts UndoHistory.new(%w{a ab abac abacus}).min_presses
puts UndoHistory.new(%w{pyramid sphinx sphere python serpent}).min_presses
puts UndoHistory.new(%w{ba a a b ba}).min_presses
