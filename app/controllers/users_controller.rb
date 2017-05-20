class UsersController < ApplicationController

  def new
    @user = User.new
  end

  def create
    user_params = params.require(:user).permit(:username, :email, :password, :password_confirmation)
    @user = User.new(user_params)
    if @user.valid?
      @user.save
      UserMailer.confirm(@user).deliver_now
      redirect_to new_user_path, success: 'Votre compte a bien été crée, vou devriez un email pour confirmer votre compte'
    else
      render 'new'
    end
  end

end