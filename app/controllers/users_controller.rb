class UsersController < ApplicationController
  skip_before_action :require_login

  def new     # will create a blank one for the form helper
    redirect_to home_path if logged_in?
    @user = User.new
  end

  def create  # form will submit here
    @user = User.new(get_params)
    if @user.save
      session[:user_id] = @user.id
      redirect_to home_path
    else
      flash[:danger] = 'There was a problem with your input. Please fix it.'
      render 'new'
    end
  end

  private

  def get_params
    params.require(:user).permit!
  end
end