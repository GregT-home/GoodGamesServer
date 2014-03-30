class GoFishyGame
  attr_reader :players, :pond, :books_list, :card_styler

  ROBOT_NAMES = ["Robbie", "R.D. Olivaw", "Speedy", "R2-D2", "C-3PO",
                 "Marvin", "Cutie", "Norby", "Johnny 5", "HAL",
                 "Mechagodzilla", "Robotman", "T-800", "T-1000",
                 "WALL-E", "EVE", "BURN-E", "Gort", "Simon"]
  
  def initialize()
    @players = []
    @books_list = {}
    @game_over = false
    @current_player_index = 0
    @game_is_started = false
    @card_styler = set_card_style("standard")
  end

  def start(cards = nil)
    return nil if @game_is_started 
    if cards.nil?
      @pond = Deck.new()
      @pond.shuffle
    else
      @pond = Deck.new(cards)
    end

    @players.each {  |player| @books_list[player] = [] }
    @current_player_index = 0
    deal(@players.count > 4 ? 5: 7)
    current_player.tell("It is your turn.")
    @game_is_started = true
  end

  def started
    @game_is_started
  end

  def pond_size
    @pond.count
  end

  def add_player(number, name)
    unless @game_is_started
      player = Player.new(number, name, Hand.new())
      @players << player
      player.tell("Waiting for the rest of the players.")
      advance_to_next_player unless @players.empty?
    end
  end

  def add_robot_player(number)
    add_player(number, ROBOT_NAMES.shuffle!.pop)
    current_player.make_robot
  end

  def set_card_style(style)
    @card_styler = CardStyler.new(style)
  end

  def current_player
    @players[@current_player_index]
  end

  def player_from_name(name)
    hit = @players.detect() { |player| player.name == name}
  end    

  def number_of_players
    @players.count
  end

  def advance_to_next_player
    @current_player_index = (@current_player_index + 1) % @players.count
  end

  def books(player)
    books_list[player]
  end

  def number_of_books(player)
    if books(player).nil? || books(player).empty?
      0
    else
      books(player).count
    end    
  end

  # check for book, if found then remove and return true, else false.
  def process_books(target_rank)
    cards = current_player.hand.give_matching_cards(target_rank)
    if cards.count == 4
      books_list[current_player] << target_rank
      return true
    else
      current_player.hand.receive_cards(cards)
      return false
    end
  end

  def play_round(target_player, target_rank)
    result = Result.new(current_player, target_player, target_rank)

    if target_player.hand.rank_count(target_rank) > 0  # has the rank
      match_cards = target_player.hand.give_matching_cards(target_rank)
      current_player.hand.receive_cards(match_cards)

      result.matches += match_cards.count
      result.received_from_player = true
    else 
      card = pond.give_card
      if card.nil?     # no cards, game is over
        @game_over = result.game_over = true
      else
        current_player.hand.receive_cards(card)
        result.received_from_pond = true
        if card.rank == target_rank  # intended match
          result.matches = 1
        else # possible surprise match
          if process_books(card.rank)
            result.book_made = true
            result.surprise_rank = card.rank
          end
          advance_to_next_player  # no intended match anywhere: turn over
        end
      end
    end
    result.book_made = process_books(target_rank) if result.book_made == nil;
    result
  end

  def check_players_for_books
    @players.each do |player|
      player.hand.cards.map do |card|
        if @game.process_books(card.rank)
          players.each { |p| p.tell "#{player.name} was dealt a book of #{card.rank}s.\n" }
          break
        end
      end
    end
  end

  def over?
    @game_over
  end

  def calculate_rankings
    player_books = []
    @players.each { |player| player_books << books(player).count }

    # Compress ties to make ranking buckets. Sort+uniq to put highest
    # num of books first.  Element number now indicates the ranking.
    bucket_list = player_books.sort.uniq.reverse

    # create an array of each player's rank
    player_books.map { |player| bucket_list.index(player) }
  end

  # Interaction methods

  def books_to_s(player)
    if books(player).nil? || books(player).empty?
      ""
    else
      books(player).map {|rank| @card_styler.rank(rank) + "s" }.sort.join(", ")
    end
  end

  def make_robot_move
    return check_endgame if out_of_cards?

    rank = current_player.hand.cards[0].rank
    return unless rank

    me = victim_number = current_player.number - 1
    while (victim_number == me) do
      victim_number = rand(number_of_players)
    end
    victim = players[victim_number]
    
    result = play_round(victim,rank)
    broadcast(result.to_s(@card_styler))
  end # make_robot_moves

  def make_human_move(victim, rank)
    broadcast("=========")
    return check_endgame if out_of_cards?

    mover = current_player
    result = play_round(victim, rank)
    broadcast(result.to_s(@card_styler))
  end # make_human_move

  def broadcast(message)
    players.each { |player| player.tell(message) }
  end

  def check_endgame
    messages = []

    # if all players are out of cards: end the game.
    players_with_cards = players.select { |p| p.hand.count > 0}
    @game_over = true if players_with_cards.empty? || pond.count == 0

    if over?
      messages << "There are no more fish in the pond.  Game play is over. Here is the final outcome:"

      rankings = calculate_rankings
      winners = 0
      rankings.each { |rank| winners += 1 if rank == 0}
      status = []
      players.each_with_index do |player, i|
        status << " #{player.name}, made #{books(player).count} books (#{books_to_s(player)})"
        if rankings[i] == 0
          status << " and is the winner!" if winners == 1
          status << " and ties for the win!" if winners > 1
        else
          status << "." if winners == 0
        end
      end
      messages << status.join(" ")
      messages << "Thank you for Playing."
      messages << "======================"
      messages.reverse.each {|msg|  broadcast(msg)}
      advance_to_next_player while current_player.robot?
    end
  end # endgame

  private

  def out_of_cards?
    if current_player.hand.cards.empty?
      broadcast("#{current_player.name} has no more cards.")
      advance_to_next_player
    end
    current_player.hand.cards.empty?
  end

  def deal(number)
    number.times do
      @players.each { |player| player.hand.receive_cards([@pond.give_card]) }
    end
  end

end # FishGame
