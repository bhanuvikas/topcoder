class EllysNewNickname

  VOWELS = %w{a e i o u y}

  def initialize nickname
    @nickname = nickname
  end

  def get_length
    nickname_letters = @nickname.chars
    new_name = []
    nickname_letters.each_with_index do |letter, i|
      new_name << letter unless is_vowel?(letter) and is_vowel?(nickname_letters[i+1])
    end
    new_name.join.size
  end

  private

  def is_vowel? letter
    VOWELS.include? letter
  end

end

puts EllysNewNickname.new("tourist").get_length
puts EllysNewNickname.new("eagaeoppooaaa").get_length
puts EllysNewNickname.new("esprit").get_length
puts EllysNewNickname.new("ayayayayayaya").get_length
puts EllysNewNickname.new("wuuut").get_length
puts EllysNewNickname.new("naaaaaaaanaaaanaananaaaaabaaaaaaaatmaaaaan").get_length
