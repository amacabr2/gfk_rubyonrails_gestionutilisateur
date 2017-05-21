class ApplicationController < ActionController::Base

  protect_from_forgery with: :exception

  before_action :only_signed_in

  add_flash_types :success
  add_flash_types :danger

  private

  def only_signed_in
    if !session[:auth] || !session[:auth]['id']
      redirect_to new_user_path, danger: "Vous n'avez pas le droit d'accèder à cette page"
    end
  end

end
