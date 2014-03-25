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
    @players = @game.players
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
    end
    game.start()

    slot = GameSlot.create(game: game,
                           game_type: game.class.name,
                           card_style: card_style)

    redirect_to game_path slot.id
  end # end create
end # end GamesController
