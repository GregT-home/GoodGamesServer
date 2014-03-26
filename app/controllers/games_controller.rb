class GamesController < ApplicationController

  def index
    @games = GameSlot.all
  end

  def show
    slot = GameSlot.find_by(id: params["id"])
    return redirect_to new_game_path unless slot

    @game = slot.game
    @card_face = CardDecorator.new(slot.card_style.to_sym)
    @current_player = @game.current_player
    @id = slot.id 
  end

  def update
    slot = GameSlot.find_by(id: params["id"])
    return redirect_to new_game_path unless slot
    styler = CardDecorator.new(slot.card_style.to_sym)

    game = slot.game
    unless game.over?
      current = game.current_player

      make_human_move(game, params, styler) unless (current.robot?)
      broadcast(game, "=========")
      while (game.current_player.robot? && ! game.over?)
        check_endgame(game, styler)
        make_robot_move(game, styler)
      end

      check_endgame(game, styler)
      slot.game = game
      slot.save
    end

    redirect_to game_path slot.id
  end


  def create
    num_robots = params["number-of-robots"].to_i
    num_humans = params["number-of-humans"].to_i
    card_style = params["card-style"].to_sym

    # future: if there is a saved game, then restore it
    # new game is created on every refresh
    game = GoFishyGame.new()
    player_number = 1
    game.add_player(player_number, "Greg")
    robot_names = ["Robbie", "R.D. Olivaw", "Speedy", "R2-D2", "C-3PO"].shuffle
    num_robots.times do
      player_number += 1
      game.add_player(player_number, robot_names.pop)
      game.current_player.make_robot
      game.players[0].tell "Added player ##{game.current_player.number}, #{game.current_player.name} to game"
    end
    game.start()

    slot = GameSlot.create(game: game,
                           game_type: game.class.name,
                           card_style: card_style)

    redirect_to game_path slot.id
  end # end create

  private

  def make_human_move(game, params, styler)
    rank = params["cards"]
    victim = game.player_from_name(params["opponents"])

    # test hack: play w/ self if no other players
    victim = game.current_player if victim.nil? && game.number_of_players == 1

    result = game.play_round(victim,rank)
    broadcast(game,
              "#{game.current_player.name}, " +
              "asked for #{styler.rank(Card.new(rank,"c"))}s " +
              "from #{victim.name}.\n#{result.to_s(styler)}")
  end # make_human_move

  def check_endgame(game, styler)
    messages = []
    if game.over?
      messages << "There are no more fish in the pond.  Game play is over. Here is the final outcome:"

      rankings = game.calculate_rankings
      winners = 0
      rankings.each { |rank| winners += 1 if rank == 0}
      status = []
      game.players.each_with_index do |player, i|
        status << " #{player.name}, made #{game.books(player).count} books (#{game.books_to_s(player, styler)})"
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
      messages.reverse.each {|msg|  broadcast(game, msg)}
      game.advance_to_next_player while game.current_player.robot?
    end
  end # endgame

  def make_robot_move(game, styler)
    current = game.current_player
    unless current.hand.cards[0]
      broadcast(game, "#{current.name} has no more cards.")
      game.advance_to_next_player
      return check_endgame(game, styler)
    end
    rank = current.hand.cards[0].rank
    return if rank.nil?

    me = victim_number = current.number - 1
    while (victim_number == me) do
      victim_number = rand(game.number_of_players)
    end
    victim = game.players[victim_number]
    
    result = game.play_round(victim,rank)
    broadcast(game,
              "#{current.name}, " +
              "asked for #{styler.rank(Card.new(rank,"c"))}s " +
              "from #{victim.name}.\n#{result.to_s(styler)}")
  end # make_robot_moves

  def broadcast(game, message)
    game.players.each { |player| player.tell(message) }
  end

end # end GamesController
