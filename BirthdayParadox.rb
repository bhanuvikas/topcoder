class BirthdayOdds

  def min_people min_odds, days_in_year

    nobody_shares_a_birthday_odds = 0.0
    two_people_share_a_birthday_odds = 0.0
    people = 0

    until two_people_share_a_birthday_odds >= min_odds or people == days_in_year
      people += 1
      factors = []
      people.times { |n| factors << (days_in_year-n-0.0) / days_in_year }
      nobody_shares_a_birthday_odds = factors.reduce :*
      two_people_share_a_birthday_odds = (1 - nobody_shares_a_birthday_odds) * 100
    end

    people

  end

end

b = BirthdayOdds.new
puts b.min_people 75, 5
puts b.min_people 50, 365
puts b.min_people 1, 365
puts b.min_people 84, 9227
