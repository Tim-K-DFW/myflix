class UsersController < ApplicationController

  def new     # will create a blank one for the form helper
    @user = User.new
  end

  def create  # form will submit here
    @user = User.new(get_params)
    if @user.save
      session[:user_id] = @user.id
      redirect_to home_path
    else
      render 'new'
    end
  end

  private

  def get_params
    params.require(:user).permit!
  end
end