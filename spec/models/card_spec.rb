# Jan-2014: Test(s) need to be added for == and related hash equivalence operators.
#  test these exhaustively to ensure proper operations of hashes, etc.
#  not needed for this project, but good to keep in mind for other time
#  == is overridden.
#  as_1 = Card("A", "S"); as_2 = Card("A", "S")
#  hash { as_1 => 'Wild')
#  expect(as1).to eql(as2)
#  expect(as1).to equal (as2)
#  expect(as1).to eql? (as2)
#  check Ken's slides for actual test set

#Dir['../tests/*.rb'].each { |file| require_relative "#{file}" }
require "fish_spec_helpers"

describe Card, ".new: cards can be created." do
  it "They have rank and suit." do
    card1 = Card.new('A','C')
    card2 = Card.new('A','H')
    
    card1.rank.should eql card2.rank
    card1.suit.should_not eql card2.suit
  end
end # cards can be created

describe Card, ".new cards have a value as well as a rank and suit." do
  it "equal, but different, cards should be equal" do
    ten_clubs = Card.new('10','C')
    ten_clubs2 = Card.new('10','C')
    ten_clubs.should eq ten_clubs2
  end

  it "higher rank should be greater than lower" do
    card = Card.new('10','H')
    card_higher = Card.new('A','S')
    expect(card_higher.value).to be > card.value
  end

  it "lower rank should be less than higher" do
    card = Card.new('10','C')
    card_lower = Card.new('2','D')
    
    card_lower.value.should be < card.value
  end
end # Pcard can be compared

