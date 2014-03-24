class GamesController < ApplicationController

  def new
  end

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

    game = slot.game
    current = game.current_player
    
    unless (current.robot?)
      rank = params["cards"]
      victim = game.player_from_name(params["opponents"])
      result = game.play_round(victim,rank)
      game.players.each do |player|
        player.tell("#{current.name}, asked for #{rank}s " +
                    "from #{victim.name}.\n#{result}")
      end
    end

    while(game.current_player.robot?) do
      make_robot_moves(game)
    end

    slot.game = game
    slot.save

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
      game.players[0].tell "Adding a new player..."
      game.players[0].tell "Added player ##{game.current_player.number}, #{game.current_player.name} to game"
    end
    game.start()

    slot = GameSlot.create(game: game,
                           game_type: game.class.name,
                           card_style: card_style)

    redirect_to game_path slot.id
  end # end create

private
  def make_robot_moves(game)

    current = game.current_player
    rank = current.hand.cards[0].rank
    return if rank.nil?

    me = victim_number = current.number
    while (victim_number == me) do
      victim_number = rand(game.number_of_players - 1)
    end
    victim = game.players[victim_number]
    
    result = game.play_round(victim,rank)
    game.players.each do |player|
      player.tell("#{current.name}, asked for #{rank}s " +
                  "from #{victim.name}.\n#{result}") # unless player.robot?
    end
  end # make_robot_moves

end # end GamesController
