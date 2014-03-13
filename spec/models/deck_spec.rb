describe Deck, "Creation and basic function" do #Deck can be created, measured, shuffled, and customized." do
  context ".new by default creates a card deck" do
    before(:each) do
      @deck  = Deck.new
      @deck2 = Deck.new
    end

    it ".count is 52 cards." do
      @deck.count.should eq 52
    end

    it "#new decks have the same order." do
      both_the_same = true
      for i in 0..(@deck.count - 1) do
        if @deck.cards[i] != @deck2.cards[i]
          both_the_same = false
          break
        end
      end

      both_the_same.should be_true
    end

    it ".shuffle changes the order." do
      @deck2.shuffle

      both_the_same = true
      for i in 0..(@deck.count - 1) do
        if @deck.cards[i] != @deck2.cards[i]
          both_the_same = false
          break
        end
      end

      both_the_same.should be_false
    end
  end
end

describe Deck, "Cards can be given to, and received by pseudo-players." do
  context ".new creates a default card deck" do
    before (:each) do
      # create a new card deck
      @deck = Deck.new

      # pseudo-players are decks with no cards.  We can't create an empty deck
      # so we create a deck with 1 card and remove it.
      @player = Deck.new([Card.new("A","H")])
      @player.give_card
    end
    

    it ".give_card can give all 52 cards to one pseudo-player." do
      @player.count.should eql 0
    end

    it ".give_card works 52 times on a standard deck and returns nil when no cards remain." do
      card = nil
      52.times {
        card = @deck.give_card
        card.should_not be nil

        @player.receive_card(card)
      }
      @player.count.should eql 52

      @deck.count.should be 0
      card.should_not be nil
    end

    it ".receive_card should be able to put all cards back into the deck" do
      card = nil
      52.times {
        card = @player.receive_card(@deck.give_card)
        card.should_not be nil
      }

    @player.count.should eql 52
    @deck.count.should eql 0

    card = nil
    52.times {
        card = @deck.receive_card(@player.give_card)
        card.should_not be nil
      }

    @player.count.should eql 0
    @deck.count.should eql 52
    end
  end
end #cards can be dealt to players


