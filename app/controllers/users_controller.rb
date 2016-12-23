class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to root_url, notice: "¡Te has registrado!"
    else
      render :new
    end
  end

  def show
  end

  def destroy
    current_user.destroy
    redirect_to log_out_path #llama al método destroy del session
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end
end
