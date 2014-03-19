class GamesController < ApplicationController

  def index
    
  end

  def show
    # future: if there is a saved game, then restore it
    # new game is created on every refresh
    @game = FishGame.new()
    player_number = 1
    @game.add_player(player_number, "Greg")
    ["Robbie", "R.D. Olivaw", "Speedy", "R2-D2", "C-3PO"].each do |robot|
      player_number += 1
      @game.add_player(player_number, robot)
      @game.current_player.make_robot
    end
    @card_face = CardDecorator.new([:standard,:shapes1,:shapes2,:fancy][rand(5)])
    @game.start()
    @current_player = @game.current_player
    @players = @game.players
  end # end show


private


end # end GamesController
