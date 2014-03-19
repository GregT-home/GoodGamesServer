class GamesController < ApplicationController

  def index
    
  end

  def show
    # future: if there is a saved game, then restore it
    # new game is created on every refresh
    @game = FishGame.new()
    @game.add_player(1, "Greg")
    @card_face = CardDecorator.new([:standard,:shapes1,:shapes2,:fancy][rand(5)])
    @game.start()
    @current_player = @game.current_player
    # @game.add_player(2, "Robbie")
    # @game.current_player.make_robot
  end # end show


private


end # end GamesController
