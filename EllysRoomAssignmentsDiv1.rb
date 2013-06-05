class EllysRoomAssignmentsDiv1

  DELTA = 0.0000000000001

  def initialize ratings
    ratings = ratings.join.split(" ")
    @elly = ratings.first.to_i
    @ratings = ratings.sort.reverse
    @number_of_rooms = (@ratings.size % 20 > 0) ? (@ratings.size/20)+1 : @ratings.size/20
  end

  def get_average

    old_avg = 200
    avg = 1200

    accum = 0
    room_accum = 0
    iterations = 0

    until (old_avg - avg).abs < DELTA
      assign_rooms
      room = ellys_room

      iterations += 1

      accum += room.reduce 0.0, :+
      room_accum += room.size + 0.0

      old_avg = avg
      avg = accum / room_accum

      if iterations % 10_000 == 0
        puts "\e[H\e[2J"
        puts "Mean: #{avg}"
        puts "Delta: #{(old_avg - avg).abs}"
        puts "Iterations: #{iterations}"
      end

    end
    avg
  end

  def assign_rooms
    @rooms = Array.new(@number_of_rooms) { Array.new }
    ratings = @ratings.dup
    until ratings.empty?
      pool = ratings.take @rooms.size
      ratings = ratings.drop @rooms.size
      @rooms.each do |room|
        person = pool.delete_at(rand(pool.size))
        room << person.to_i if person
      end
      #@rooms.each do |room|
        #person = ratings.delete_at(rand(ratings.size))
        #room << person.to_i if person
      #end
    end
  end

  def ellys_room
    @rooms.find { |r| r.include? @elly }
  end

end

test_1 = ["1924 1242 1213 1217 2399 1777 2201 2301 1683 2045 ", "1396 2363 1560 2185 1496 2244 2117 2207 2098 1319 ",
 "2216 1223 1256 2359 2394 1572 2151 2191 2147 2253 ", "1633 2217 2211 1591 1310 1209 1430 1445 1988 2030 ",
 "1947 1202 1203"]

puts EllysRoomAssignmentsDiv1.new(test_1).get_average
