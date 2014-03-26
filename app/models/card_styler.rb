class CardStyler
  DECORATION_STYLES = {
    "standard" => {suits: Card::SUITS,  ranks: Card::RANKS },
    "fancy"    => {suits: %w(c d h s), ranks: %w(2 3 4 5 6 7 8 9 10 j q k a) },
    "shapes1"  => {suits: %w(a b c d), ranks: %w(carrot sun star watermelon banana pin umbrella cloud button heart flower screw moon) },
    "shapes2"  => {suits: %w(a b c d), ranks: %w(grapes tv cactus pie rocket bulb plant cup crown pacman cheese smiley envelope) }
  }

  def initialize(style = nil)
    @style = style
    @style = "standard" if DECORATION_STYLES[style].nil?
  end

  def image_name(card)
    "#{@style}/#{suit(card.suit).downcase}_#{rank(card.rank).downcase}.png"
  end

  def text_name(card)
    "#{rank(card.rank)}-of-#{suit(card.suit)}"
  end

  def rank(rank_code)
    standard_ranks = DECORATION_STYLES["standard"][:ranks]
    ranks = DECORATION_STYLES[@style][:ranks]
    ranks[standard_ranks.index(rank_code.downcase)].upcase
  end

  def rank_option_list(card)
    standard_ranks = DECORATION_STYLES["standard"][:ranks]
    ranks = DECORATION_STYLES[@style][:ranks]
    [ranks[standard_ranks.index(card.rank.downcase)].upcase, card.rank]
  end

  def suit(suit_code)
    standard_suits = DECORATION_STYLES["standard"][:suits]
    suits = DECORATION_STYLES[@style][:suits]
    suits[standard_suits.index(suit_code.downcase)].upcase
  end
end
