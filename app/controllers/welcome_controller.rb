class WelcomeController < ApplicationController
  def index
    redirect_to game_path(id: "1") if user_signed_in?
  end

end

