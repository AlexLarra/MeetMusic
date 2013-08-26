# -*- encoding : utf-8 -*-
class SessionsController < ApplicationController
  def new  
  end  
    
  def create
    user = User.authenticate(params[:email], params[:password])  
    if user  
      session[:user_id] = user.id
      redirect_to songs_url#, notice: "¡Te has logueado!"
    else  
      flash.now.alert = "Email o password inválidos"  
      render "new"  
    end  
  end  
  
  #desconectarse
  def destroy  
    session[:user_id] = nil  
    redirect_to root_url#, notice: "Te has desconectado"  
  end  
  
end
