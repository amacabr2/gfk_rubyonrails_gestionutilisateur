class SessionsController < ApplicationController

  skip_before_action :only_signed_in, only: [:new, :create]

  def new
  end

  def create
  end

  def destroy
  end

end
