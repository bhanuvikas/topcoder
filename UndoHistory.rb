class WeirdEditor

  def initialize lines
    @given_lines = lines
    @results = []
    @buffer = ""
    @history = [] << ""
    @presses = 0
  end

  def min_presses
    @given_lines.each do |line|
      best = undo_best_matching_history_item line
      line = line[best.size..-1] if best
      undo "" unless @buffer.empty? or best
      input_string line
      enter
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
    undo match if match && match.size > 1
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

puts WeirdEditor.new(%w{tomorrow topcoder}).min_presses
puts WeirdEditor.new(%w{a b}).min_presses
puts WeirdEditor.new(%w{a ab abac abacus}).min_presses
puts WeirdEditor.new(%w{pyramid sphinx sphere python serpent}).min_presses
puts WeirdEditor.new(%w{ba a a b ba}).min_presses
