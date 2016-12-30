class SessionsController < ApplicationController
  def new
    redirect_to songs_url if current_user
  end

  def create
    user = User.authenticate(params[:email], params[:password])
    if user
      session[:user_id] = user.id
      redirect_to songs_url
    else
      flash.now.alert = "Email o password inválidos"
      render :new
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_url
  end
end
