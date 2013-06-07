class Collision

  def probability assigments, ids
    @assignments = assigments
    @ids = ids

    dumb = dumb_probability
    smart = smart_probability

    puts "dumb: #{dumb}"
    puts "smart: #{smart}"

    (dumb - smart).abs
  end

  def dumb_probability
    odds_of_no_collision = 1.0
    id_pool = @ids + 0.0
    @assignments.reduce(:+).times do
      odds_of_no_collision *= id_pool / @ids
      id_pool -= 1
    end
    odds_of_no_collision
  end

  def smart_probability
    odds_of_no_collision = 1.0
    id_pool = @ids + 0.0
    @assignments.reduce(:+).times do
      odds_of_no_collision *= id_pool / @ids
      id_pool -= 1
    end
    odds_of_no_collision
  end

end

c = Collision.new
puts c.probability [20, 20], 1000
puts c.probability [123, 456], 123456
