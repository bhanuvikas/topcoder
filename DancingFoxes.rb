class Fox

  attr_accessor :friends, :history, :dancing
  attr_reader :number

  def initialize friends=[], number=0
    @friends = friends
    @history = []
    @dancing = false
    @number = number
  end

  def dance_with fox
    unless @dancing or fox.dancing
      @friends << fox
      @history << fox
      @dancing = true
      fox.friends << self
      fox.history << self
      fox.dancing = true
    end
  end

  def foxes_left_to_dance_with
    (@friends.flat_map { |f| f.friends.to_a } - @history - @friends - [self]).sort_by { |f| f.number }
  end

  def dance_with_a_new_partner
    pool = foxes_left_to_dance_with
    dance_with pool.first unless pool.empty?
  end

  def is_friends_with? fox
    @friends.include? fox
  end

  # for debug
  def to_s
    "<Fox:#{number}>"
  end

end


class DancingFoxes

  def initialize friendship
    @friendship = friendship.map { |line| line = line.chars }
    @foxes = []
    @friendship.size.times { |i| @foxes << Fox.new([],i) }
    @friendship.each_with_index do |friend_list, i|
      friend_list.each_with_index do |f,j|
        @foxes[i].friends << @foxes[j] if f == 'Y'
      end
    end
  end

  def minimal_days
    dances = 0
    loop do
      break if ciel_and_jiro_are_friends? or no_more_fox_pairs?
      @foxes.each { |f| f.dancing = false }
      @foxes.each { |f| f.dance_with_a_new_partner }
      dances += 1
    end
    dances = -1 unless ciel_and_jiro_are_friends?
    dances
  end

  private

  def ciel_and_jiro_are_friends?
    @foxes[0].is_friends_with? @foxes[1]
  end

  def no_more_fox_pairs?
    @foxes.flat_map { |fox| fox.foxes_left_to_dance_with.to_a }.empty?
  end

  # for debugging
  def friend_matrix
    @foxes.map do |i|
      @foxes.map { |j| i.is_friends_with?(j).to_s[0].upcase }.join " "
    end
  end

end

puts DancingFoxes.new(%w{NNY NNY YYN}).minimal_days
puts DancingFoxes.new(%w{NNNNN NNYYY NYNYY NYYNY NYYYN}).minimal_days
puts DancingFoxes.new(%w{NNYYNN NNNNYY YNNNYN YNNNNY NYYNNN NYNYNN}).minimal_days
test_4 = ["NNYNNNNYN", "NNNNYNYNN", "YNNYNYNNN", "NNYNYNYYN", "NYNYNNNNY", "NNYNNNYNN", "NYNYNYNNN", "YNNYNNNNY", "NNNNYNNYN"]
puts DancingFoxes.new(test_4).minimal_days
puts DancingFoxes.new(%w{NY YN}).minimal_days
