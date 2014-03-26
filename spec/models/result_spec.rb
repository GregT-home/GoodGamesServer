describe Result, "Round Result creation and manipulation." do
  context "Round results need an active game." do
    before :each do
      @game = GoFishyGame.new()
      @game.add_player(101, "Test1")
      @game.add_player(102, "Test2")
      @game.start()
    end

    it "A Round Result can be created." do
      result = Result.new(@game.current_player, @game.players[1], "3")

      result.requester.should == @game.current_player
      result.victim.should == @game.players[1]
      result.rank.should == "3"
      result.matches.should == 0
      result.received_from_player.should == nil
      result.received_from_pond.should == nil
      result.book_made.should == nil
      result.game_over.should == false

      expect {result.requester = 1}.to raise_error
      expect {result.victim = 2}.to raise_error
      expect {result.rank = 3}.to raise_error
    end

    it "A Round Results can have its values changed." do
      result = Result.new(@game.current_player, @game.players[1], "3")

      expect {result.requester = 1}.to raise_error
      expect {result.victim = 2}.to raise_error
      expect {result.rank = 3}.to raise_error
      result.matches                 = 4
      result.received_from_player    = true
      result.book_made               = false
      result.game_over               = 6

      result.requester.should       == @game.current_player
      result.victim.should          == @game.players[1]
      result.rank.should            == "3"
      result.matches.should         == 4
      result.received_from_player.should   == true
      result.book_made.should       == false
      result.game_over.should       == 6
    end

    context ".to_str" do
      it "case 1: ask Victim: none; Pond: Yes; Book: N/A; turn over." do
        regexp = Regexp.new("Test1 asked for 3s from Test2\\s+" +
                            "and was told to 'Go Fish.'\\s+" +
                            "Test1 got one from the pond!\s+" +
                            "Test1 did not make a book.")
        result = Result.new(@game.players[0],@game.players[1],"3")
        result.matches = 1
        result.received_from_pond = true
        result.book_made = false
        result.game_over = false

        result.to_s.should =~ regexp
      end

      it "case 2: ask Victim: gets; Pond: N/A; Book: N/A; plays again." do
        regexp = Regexp.new("Test1 asked for 3s from Test2\\s+" +
                            "and got 2.\\s+" +
                            "Test1 did not make a book.")
        result = Result.new(@game.players[0],@game.players[1],"3")
        result.matches = 2
        result.received_from_player = true
        result.book_made = false
        result.game_over = false

        result.to_s.should =~ regexp
      end

      it "case 3: ask Victim: gets; Pond: N/A; Book: Yes; plays again." do
        regexp = Regexp.new("Test1 asked for 2s from Test2\\s+" +
                            "and got 2.\\s+" +
                            "Test1 made a book of 2s.")
        result = Result.new(@game.players[0],@game.players[1],"2")
        result.matches = 2
        result.received_from_player = true
        result.book_made = true
        result.game_over = false

        result.to_s.should =~ regexp
      end

      it "case 4: ask Victim: no get; Pond: get; Book: no; plays again." do
        regexp = Regexp.new("Test1 asked for 3s from Test2\\s+" +
                            "and was told to 'Go Fish.'\\s+" +
                            "Test1 got one from the pond!\s+" +
                            "Test1 did not make a book.")
        result = Result.new(@game.players[0],@game.players[1],"3")
        result.matches = 1
        result.received_from_pond = true
        result.book_made = false
        result.game_over = false

        result.to_s.should =~ regexp
      end

      it "case 5: ask Victim: no get; Pond: get; Book: yes; plays again." do
        regexp = Regexp.new("Test1 asked for 3s from Test2\\s+" +
                            "and was told to 'Go Fish.'\\s+" +
                            "Test1 got one from the pond!\s+" +
                            "Test1 made a book of 3s.")
        result = Result.new(@game.players[0],@game.players[1],"3")
        result.matches = 1
        result.received_from_pond = true
        result.book_made = true
        result.game_over = false

        result.to_s.should =~ regexp
      end
      
      it "case 6: ask Victim: no get; Pond: get; Book: yes--surprise; next player." do
        regexp = Regexp.new("Test1 asked for Qs from Test2\\s+" +
                            "and was told to 'Go Fish.'\\s+" +
                            "Test1 got one from the pond!\s+" +
                            "Test1 was surprised to make a book of 3s.")
        result = Result.new(@game.players[0],@game.players[1],"Q")
        result.matches = 1
        result.received_from_pond = true
        result.book_made = true
        result.surprise_rank = "3"
        result.game_over = false

        result.to_s.should =~ regexp
      end
      
      it "end case: ask Victim: no get; Pond: get; Book: yes; plays again." do
        regexp = Regexp.new("Test1 asked for 3s from Test2\\s+" +
                            "and was told to 'Go Fish.'\\s+" +
                            "Test1 did not get any from the pond.\s+" +
                            "Test1 did not make a book.\\s+" +
                            "The game is now over.")
        result = Result.new(@game.players[0],@game.players[1],"3")
        result.matches = 0
        result.received_from_player = nil
        result.received_from_pond = nil
        result.book_made = false

        result.game_over = true

        result.to_s.should =~ regexp
      end
    end # to_s tests
  end # context
end # round results creation/manipulation
