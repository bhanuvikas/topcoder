class PipeCuts

  def probability weld_locations, target_length

    tries = 0.0
    successes = 0.0

    weld_locations.combination(2).each do |welds|
      welds.sort!
      piece_one_length = welds[0]
      piece_two_length = welds[1] - piece_one_length
      piece_three_length = 100 - (piece_one_length + piece_two_length)
      tries += 1
      if (piece_one_length > target_length ||
          piece_two_length > target_length ||
          piece_three_length > target_length)
        successes += 1
      end
    end

    successes / tries

  end

end

p = PipeCuts.new
puts p.probability [25, 50, 75], 25
puts p.probability [25, 50, 75], 50
puts p.probability [25, 50, 75], 24
puts p.probability [99, 88, 77, 66, 55, 44, 33, 22, 11], 50
