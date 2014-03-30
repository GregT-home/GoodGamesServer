class GamesController < ApplicationController

  def index
    @games = GameSlot.all
  end

  def show
    return redirect_to new_game_path unless slot = GameSlot.find_by(id: params["id"])

    @game = slot.game
    @game.set_card_style(slot.card_style) if @game.card_styler.nil?
    @current_player = @game.current_player
    @id = slot.id 
  end

  def update
    return redirect_to new_game_path unless slot = GameSlot.find_by(id: params["id"])
    game = slot.game

    unless game.over?
      unless game.current_player.robot?
        rank = params["cards"]
        victim = game.player_from_name(params["opponents"])

        # tmp test hack: play w/ self if no other players
        victim = current_player if victim.nil? && number_of_players == 1

        game.make_human_move(victim, rank)
      end

      while (game.current_player.robot? && ! game.over?)
        game.check_endgame
        game.make_robot_move
      end
      game.check_endgame

      slot.game = game
      slot.save
    end

    redirect_to game_path slot.id
  end


  def create
    human_name = params["human-name"]
    num_robots = params["number-of-robots"].to_i
    num_humans = params["number-of-humans"].to_i
    card_style = params["card-style"]

    # future: if there is a saved game, then restore it
    # new game is created on every refresh
    game = GoFishyGame.new()
    game.set_card_style(card_style)
    player_number = 1
    game.add_player(player_number, human_name)
    num_robots.times do
      player_number += 1
      game.add_robotplayer(player_number)
      game.players[0].tell "Added player ##{game.current_player.number}, #{game.current_player.name} to game"
    end
    game.start()

    slot = GameSlot.create(game: game,
                           game_type: game.class.name,
                           card_style: card_style)

    redirect_to game_path slot.id
  end # end create
end # end GamesController
