class GamesController < ApplicationController

  def index
    
  end


  def show
    # future: if there is a saved game, then restore it
    if @game.nil?
      @game = Game.new()
      @game.add_player(1, "Greg")
      @game.start()
      @my = @game.current_player
      # @game.add_player(2, "Robbie")
      # @game.current_player.make_robot
    end
  end # end show

end
