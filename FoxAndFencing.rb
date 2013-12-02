class FoxAndFencing
  def initialize mov1, mov2, rng1, rng2, d
    @ciel = { move: mov1, range: rng1, cell: 0 }
    @liss = { move: mov2, range: rng2, cell: d }
  end

  def who_can_win
    # edge: if during the first turn, ciel can strike liss, ciel wins
    if @ciel[:move] + @ciel[:range] >= @liss[:cell]
      "Ciel"
    # edge: if liss has a large enough range then she wins before ciel can get away
    elsif @liss[:range] - @liss[:cell] > @ciel[:move]
      "Liss"
    # edge: if ciel's move and range are greater than liss', ciel is going to win
    elsif @liss[:move] < @ciel[:move] && @ciel[:move] + @ciel[:range] > @liss[:move] + @liss[:range]
      "Ciel"
    else
      "Draw"
    end
  end
end

[
  [[1, 58, 1, 58, 2], "Ciel"],
  [[2, 1, 1, 100, 50], "Liss"],
  [[2, 1, 1, 100, 150], "Draw"],
  [[100, 100, 100, 100, 100000000], "Draw"],
  [[100, 1, 100, 1, 100000000], "Ciel"],
  [[100, 1, 100, 250, 100000000], "Draw"],
  [[100, 1, 100, 150, 100000000], "Ciel"],
  [[100, 50, 100, 1, 100000000], "Ciel"],
  [[100, 150, 100, 1, 100000000], "Draw"]
].each do |tester|
  puts FoxAndFencing.new(*tester[0]).who_can_win == tester[1]
end
