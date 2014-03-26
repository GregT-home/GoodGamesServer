class Result
  attr_reader :requester, :victim, :rank
  attr_accessor :matches, :received_from_player, :received_from_pond
  attr_accessor :book_made
  attr_accessor :surprise_rank, :game_over

  def initialize(requester, victim, rank)
    @requester = requester
    @victim = victim
    @rank = rank

    @matches = 0
    @received_from = nil

    @book_made = nil
    @surprise_rank = nil
    @game_over = false
  end

  def to_s(styler = nil)
    styled_rank          = styler ? styler.rank(@rank) : @rank
    name = @requester.name
    match_status = []
    match_status << "#{name} asked for #{styled_rank}s from #{@victim.name}"

    if received_from_player
      match_status << "and got #{matches}."
    else
      match_status << "and was told to 'Go Fish.' "
      if matches == 0
        match_status << "#{name} did not get any from the pond."
      else
        match_status << "#{name} got one from the pond!"
      end
    end

    if ! book_made
      match_status << "#{name} did not make a book."
    else
      if surprise_rank
        styled_surprise_rank = styler ? styler.rank(@surprise_rank) : @surprise_rank
        match_status << "#{name} was surprised to make a book of #{styled_surprise_rank}s."
      else
        match_status << "#{name} made a book of #{styled_rank}s."
      end
    end

    if game_over
      match_status << "The game is now over."
    end

    match_status.join(" ")
  end
end # Result
