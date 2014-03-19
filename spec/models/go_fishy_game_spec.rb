require "go_fishy_spec_helpers"

describe GoFishyGame, "Methods prior to game start." do
  context "Create a basic game unstarted game." do
    before :each do
      @game = GoFishyGame.new()
      @game.add_player(501, "One")

      @current_player = @game.current_player
    end
    
    it "#new: creates a Fish game" do
      expect(@game).to be_kind_of(GoFishyGame)
    end

    it "#add_player: adds a new player" do
      expect(@game.players.first).to be_kind_of(Player)
    end

    it ".started is false when a game is created" do
      expect(@game.started).to be_false
    end
  end
end # tests for unstarted game

describe GoFishyGame, "Methods for a running game." do
  context "Create a basic game running game." do
    before :each do
      @game = GoFishyGame.new()
      @game.add_player(501, "One")
      @game.start()

      @current_player = @game.current_player
    end
    
    it ".started is true when the game is started" do
      expect(@game.started).to be_true
    end

    it ".start returns nil if game is already started" do
      result = @game.start
      expect(result).to eq nil
    end

    it ".add_player returns nil if game is started" do
      result = @game.add_player(1, "A Player")
      expect(result).to eq nil
    end
  end
end # tests for running game

describe GoFishyGame, "Methods for a multi-player game." do
  context "Use #new, and #add_player to set up multi-player game." do
    before :each do
      names = %w(One Two Three Four Five)

      @number_of_test_players = names.count
      @hand_length = 5
      @game = GoFishyGame.new()

      names.each_with_index { |name, i| @game.add_player(i+10, name) }
      @game.start()

    end # before :each
    
    it "#add_player: multiple players are set up properly" do
      @game.players.each { |player| player.hand.count.should be @hand_length }
    end

    it "#current_player is a player and the 'first' player" do
      expect(@game.current_player).to be_kind_of(Player)
      @game.current_player.should eql @game.players.first
    end

    it "#advance_to_next_player advances the index to the next player" do
      prev_player = @game.current_player
      @game.advance_to_next_player
      @game.current_player.should_not eq prev_player
    end

    it "#advance_to_next_player goes around in an ordered loop of players." do
      first_player = @game.current_player
      @number_of_test_players.times { @game.advance_to_next_player }
      @game.current_player.should eql first_player
    end
  end # context for random players
end # multi-player game setup tests

describe GoFishyGame, "Test game play logic." do
  context "Create a game with a stacked of known player hands." do
    before :each do
      names = %w(First Second Third)
      @number_of_test_players = names.count
      @hand_size = 7

      test_deck = GoFishySpecHelpers.cards_from_hand_s( "2C 2H 3C QH 5C 4H 9H",
                                          "2S 2D 3S 3D 5S 4D 9C",
                                          "10C 10H 10S 10D AC AH 9S")
      test_deck.unshift(Card.new("3", "H"))  # add an extra card

      @game = GoFishyGame.new()
      names.each_with_index { |name, i| @game.add_player(i+20, name) }
      @game.start(test_deck)
    end # before :each

    it "Test Deck results in expected hands." do
      @game.number_of_players.should be @number_of_test_players
      @game.players.each { |player| player.hand.count.should be @hand_size }

      # test a few samples for validity
      @game.players.first.hand.cards[0].should eq Card.new("Q", "H")
      @game.players[2].hand.cards[3].should eq Card.new("10", "C")
      @game.pond.cards.first.should eq Card.new("3", "H")
    end


    it "#check_players_for_books logic: check for books in initial hands" do
      expected_result = [0, 0, 1] # 1st two players have none, third has 1

      @game.players.each_with_index do |player, i|
        player.hand.cards.each do |card|
          if @game.process_books(card.rank)
            book_found.should eq expected_result[i]
            break
          end
        end
      end
    end

    it ".play_round, typical case 1: ask Victim: none; Pond: No; Book: N/A; next player." do
      start_player = @game.current_player
      started_with = start_player.hand.rank_count("4")

      result = @game.play_round(@game.players[2], "4")  # hand 2 has no 4s, nor the pond

      result.requester.should eq start_player
      result.victim.should eq @game.players[2]
      result.rank.should eq "4"
      result.matches.should eq 0
      result.received_from_pond.should be_true
      result.book_made.should be_false

      started_with.should eq start_player.hand.rank_count("4");

      @game.current_player.should_not eql start_player
    end

    it ".play_round, typical case 2: ask Victim: gets; Pond: N/A; Book: no; plays again." do
      start_player = @game.current_player
      started_with = start_player.hand.rank_count("3")

      result = @game.play_round(@game.players[1], "3")  # hand 1 has 2 x 3s
      result.matches.should eq 2
      result.received_from_player.should be_true
      result.book_made.should be_false

      @game.current_player.hand.rank_count("3").should eq started_with + 2
      @game.current_player.should eql start_player
    end

    it ".play_round, typical case 3: ask Victim: gets; Pond: N/A; Book: Yes; plays again." do
      starting_player = @game.current_player

      result = @game.play_round(@game.players[1], "2")  # hand 1 has 2 x 2s
      result.matches.should eq 2
      result.received_from_player.should be_true
      result.book_made.should be_true

      @game.current_player.hand.rank_count("2").should eq 0 # book removed from hand
      @game.current_player.should eq starting_player
      @game.books(@game.current_player).should include("2")
    end

    it ".play_round, typical case 4: ask Victim: no get; Pond: get; Book: no; plays again." do
      starting_player = @game.current_player
      started_with = starting_player.hand.rank_count("3")

      result = @game.play_round(@game.players[2], "3")  # hand 2 has no 3s, pond does
      result.matches.should eq 1
      result.received_from_pond.should be_true
      result.book_made.should be_false


      @game.current_player.hand.rank_count("3").should eq started_with + 1
      @game.current_player.should eq starting_player
    end

    it ".play_round, typical case 5: ask Victim: no get; Pond: get; Book: yes; plays again." do
      # we play 2 hands to get to do this
      starting_player = @game.current_player
      @game.play_round(@game.players[1], "3") #hand 1 has 2 x 3s (test case 2)

      result = @game.play_round(@game.players[2], "3")  # hand 2 has no 3s, but pond does
      result.matches.should eq 1
      result.received_from_pond.should be_true
      result.book_made.should be_true

      @game.current_player.hand.rank_count("3").should eq 0
      @game.current_player.should eq starting_player
      @game.books(@game.current_player).should include("3")
    end

    it ".play_round, typical case 6: ask Victim: no get; Pond: get; Book: yes-surprise; next player." do
      # we play 2 hands to get to do this
      starting_player = @game.current_player
      @game.play_round(@game.players[1], "3") #hand 1 has 2 x 3s (test case 2)

      result = @game.play_round(@game.players[2], "Q")  # hand 2 has no Qs, pond has a 3 for book
      result.matches.should eq 0
      result.received_from_pond.should be_true
      result.surprise_rank.should eq "3"
      result.book_made.should be_true
      @game.current_player.hand.rank_count("3").should eq 0
      @game.current_player.should_not eql starting_player
      @game.books(starting_player).should include("3")
    end

    context "Utility methods do helpful things" do
      it ".play_round: checks for end of game" do
        #take last card from deck
        card = @game.pond.give_card
        @game.pond.count.should eq 0

        next_card = @game.pond.give_card
        next_card.should be_nil

        # Play a round: ask for 3 from hand 2, don't get one, don't get from pond
        result = @game.play_round(@game.players[2], "3")
        result.received_from_player.should be_nil
        result.received_from_pond.should be_nil
        result.matches.should eq 0
        
        result.game_over.should be_true
        @game.over?.should be_true
      end # check for end of game

      it ".calculate_rankings: it determines player ranking" do
        # Player 1 wins, Player 2 comes second, 0 is third
        @game.books_list[@game.players[1]] = ["Q", "2", "7"]
        @game.books_list[@game.players[2]] = ["A"]

        rank_list = @game.calculate_rankings
        rank_list.should eq [2, 0, 1]
      end

      it ".calculate_rankings: it shows ties" do

        # Players 1 & 2 both have 2
        @game.books_list[@game.players[1]] = ["Q", "2"]
        @game.books_list[@game.players[2]] = ["7", "A"]

        rank_list = @game.calculate_rankings
        rank_list.should eq [1, 0, 0]
      end

      it ".books_to_s returns null string when no books" do
        @game.books_to_s(@game.current_player).should eq  ""
      end

      it ".books_to_s can display a list of books" do
        # Remove any matching cards from the current hand
        @game.current_player.hand.give_matching_cards("2")
        @game.current_player.hand.give_matching_cards("K")
        @game.current_player.hand.give_matching_cards("A")

        # Stack the hand with three books
        cards = GoFishySpecHelpers.cards_from_hand_s("2C 2S 2D 2H KC KS KD KH AC AS AD AH")
        @game.current_player.hand.receive_cards(cards)

        # check the hand for each kind of book
        @game.process_books("2").should be_true
        @game.process_books("K").should be_true
        @game.process_books("A").should be_true

        book_list = "2s, As, Ks"
        @game.books_to_s(@game.current_player).should eq book_list
      end
    end # utility methods
  end # context create known hands
end # test game play logic


