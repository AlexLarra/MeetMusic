# -*- encoding : utf-8 -*-
class UsersController < ApplicationController
  def new  
    @user = User.new  
  end  
    
  def create  
    @user = User.new(params[:user])  
    if @user.save  
      redirect_to root_url, :notice => "¡Te has registrado!"  
    else  
      render "new"  
    end  
  end
  
  def show
    
  end
  
  def destroy
    current_user.destroy
    redirect_to log_out_path #llama al método destroy del session 
  end
  
  
end
