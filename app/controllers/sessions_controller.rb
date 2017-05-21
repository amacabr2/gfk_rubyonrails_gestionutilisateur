class SessionsController < ApplicationController

  skip_before_action :only_signed_in, only: [:new, :create]

  def new
  end

  def create
    user_params = params.require(:user)
    @user = User.where(username: user_params[:username]).or(User.where(email: user_params[:username])).first
    if @user and @user.authenticate(user_params[:password]) and @user.confirmed == true
      session[:auth] = @user.to_session
      redirect_to profil_path, success: 'Connexion réussi'
    else
      redirect_to new_session_path, danger: 'Identification incorrecte'
    end
  end

  def destroy
  end

end
