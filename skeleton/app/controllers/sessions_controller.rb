class SessionsController < ApplicationController
  
  def new 
    @user = User.new
    render :new
  end
  
  def create 
    @user = User.find_by_credentials(
      params[:user][:username],
      params[:user][:password]
    )
    
    if @user 
      login!(@user) # write this later
      redirect_to user_url(@user)
    else
      flash.now[:errors] = ['Invalid login credentials!']
      render :new
    end
  end
  
  
  def destroy
    
    if current_user 
      current_user.reset_session_token!
      session[:session_token] = nil
      @current_user = nil      
    end
    redirect_to new_session_url
  end
  
end