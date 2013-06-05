class QuizShow

  def wager scores, player_one_wager, player_two_wager
    # look at all the possible outcomes and act according to the
    # most advantageous one.

    my_score, player_one_score, player_two_score = scores
    my_wager = 0
    best_bet = 0
    best_odds = 0

    while my_wager <= my_score
      # given each possible wager, look at all the possible outcomes
      # the one yielding the most possible good outcomes is the best
      number_of_good_outcomes = 0
      [-1,1].each do |player_one_answer|
        [-1,1].each do |player_two_answer|
          [-1,1].each do |my_answer|
            p1 = (player_one_answer * player_one_wager) + player_one_score
            p2 = (player_two_answer * player_two_wager) + player_two_score
            me = (my_answer * my_wager) + my_score
            number_of_good_outcomes += 1 if me > p1 && me > p2
            if number_of_good_outcomes > best_odds
              best_bet = my_wager
              best_odds = number_of_good_outcomes
            end
          end
        end
      end
      my_wager += 1
    end

    best_bet

  end

end

q = QuizShow.new
puts q.wager [100,100,100], 25, 75
puts q.wager [10,50,60], 30, 41
puts q.wager [10,50,60], 31, 41
puts q.wager [2,2,12], 0, 10
