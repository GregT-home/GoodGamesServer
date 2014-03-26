class GamesController < ApplicationController

  def index
    @games = GameSlot.all
  end

  def show
    slot = GameSlot.find_by(id: params["id"])
    return redirect_to new_game_path unless slot

    @game = slot.game
    @current_player = @game.current_player
    @id = slot.id 
  end

  def update
    slot = GameSlot.find_by(id: params["id"])
    return redirect_to new_game_path unless slot

    game = slot.game

    unless game.over?
      current = game.current_player

      game.make_human_move(params) unless (current.robot?)
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
    num_robots = params["number-of-robots"].to_i
    num_humans = params["number-of-humans"].to_i
    card_style = params["card-style"]

    # future: if there is a saved game, then restore it
    # new game is created on every refresh
    game = GoFishyGame.new()
    game.set_card_style(card_style)
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
end # end GamesController
