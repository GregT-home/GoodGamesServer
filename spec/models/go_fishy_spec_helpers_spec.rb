describe GoFishySpecHelpers, ".new: cards can be generated from rank/suit strings." do
  it ".new: can be done one or more times" do
    static_cards = [Card.new('A','C'),
                    Card.new('2','C'),
                    Card.new('3','C') ]
    static_cards[0].rank.should eql "A"
    static_cards[0].suit.should eql "C"
    static_cards[1].rank.should eql "2"
    static_cards[1].suit.should eql "C"
    static_cards[2].rank.should eql "3"
    static_cards[2].suit.should eql "C"
  end

  it ".card_from_hand_s: a card can be created from string" do
    card = GoFishySpecHelpers.cards_from_hand_s("A-C")[0]
    card.rank.should eql "A"
    card.suit.should eql "C"
  end

  it ".cards_from_hand_s: multiple cards can be created from string" do
    cards = GoFishySpecHelpers.cards_from_hand_s("A-C 3C 4c")

    cards.each { |card|
      expect(card).to be_kind_of(Card)
    }
  end

  it ".card_from_s: a single card can be created and represented as a string" do
    card = GoFishySpecHelpers.card_from_s("2-H")
    expect(card).to be_kind_of(Card)
    card.to_s.should eq "2-H"
  end
end # test cards can be created from strings
