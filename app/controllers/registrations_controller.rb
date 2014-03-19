class RegistrationsController < Devise::RegistrationsController
  protected

  def after_sign_up_path_for(resource)
    redirect_to game_path(id: "1")
  end
  def after_sign_in_path_for(resource)
    redirect_to game_path(id: "1")
  end
end
