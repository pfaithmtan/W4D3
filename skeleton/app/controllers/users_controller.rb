class UsersController < ApplicationController
  
  def new 
    @user = User.new
    render :new
    # render json: @user
  end 
  
  def create 
    @user = User.new(user_params)
    
    redirect_to user_url(@user)
  end 
  
  private 
  
  def user_params 
    params.require(:user).permit(:username, :password)
  end
  
end 