class EllysRoomAssignmentsDiv1

  def initialize ratings
    ratings = ratings.join.split(" ")
    @elly = ratings.first.to_i
    @ratings = ratings.map(&:to_i).sort.reverse
    @number_of_rooms = (@ratings.size % 20 > 0) ? (@ratings.size/20)+1 : @ratings.size/20
  end

  def get_average

    # with the ordered list of ratings, find elly's index
    # remove the other two ratings that elly cannot share a room with
    # get the avg of all remaining scores?

    ellys_index = @ratings.index @elly
    ellys_round = ellys_index / @number_of_rooms

    ellys_set_start = @number_of_rooms * ellys_round
    ellys_set = @ratings[(ellys_set_start)..(ellys_set_start+@number_of_rooms-1)]

    #ellys_set.delete @elly
    ellys_set.each do |exclude|
      @ratings.delete exclude
      #@ratings << @elly
    end


    # avgs need to account for different room sizes
    # ex. with 3 rooms, elly will end up in each one once

    puts @ratings.reduce :+
    @ratings.reduce(:+) / (@ratings.size + 0.0)

  end

end

test_1 = ["1924 1242 1213 1217 2399 1777 2201 2301 1683 2045 ", "1396 2363 1560 2185 1496 2244 2117 2207 2098 1319 ",
 "2216 1223 1256 2359 2394 1572 2151 2191 2147 2253 ", "1633 2217 2211 1591 1310 1209 1430 1445 1988 2030 ",
 "1947 1202 1203"]

puts EllysRoomAssignmentsDiv1.new(test_1).get_average
