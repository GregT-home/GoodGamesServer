class Card
  attr_reader :rank, :suit

  # define constants so we can use the same literal strings in deck
  RANKS = %w(2 3 4 5 6 7 8 9 10 j q k a)
  SUITS = %w(c d h s)

  def initialize(myrank, mysuit)
    @rank = myrank
    @suit = mysuit
  end

  def value
    RANKS.index(@rank.downcase)
  end

  def to_s
    "#{@rank.upcase}-#{@suit.upcase}"
  end

  def == card
    rank == card.rank && suit == card.suit
  end
end # Card
