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
    if received_from_player
      match_status = "Player got #{matches}."
    else
      match_status = "Player was told to 'Go Fish' and "
      if matches == 0
        match_status += "he did not get what he asked for from the pond."
      else
        match_status += "he got one from the pond!"
      end
    end

    match_status += "\n"
    
    if ! book_made
      book_status = "He did not make a book."
    else
      if surprise_rank
        display_rank = styler ? styler.rank(Card.new(surprise_rank, "c")) : surprise_rank
        book_status = "He was surprised to make a book of #{display_rank}s."
      else
        display_rank = styler ? styler.rank(Card.new(rank, "c")) : rank
        book_status = "He made a book of #{display_rank}s."
      end
    end

    if game_over
      game_status = "\nThe Game is now over"
    else
      game_status = ""
    end

    match_status + book_status + game_status
  end
end # Result
