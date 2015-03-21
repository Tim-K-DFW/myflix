class UsersController < ApplicationController
  skip_before_action :require_login, only: [:new, :create]

  def new     # will create a blank one for the form helper
    redirect_to home_path if logged_in?
    @user = User.new
  end

  def show
    @user = User.find(params[:id])
  end

  def create  # form will submit here
    @user = User.new(get_params)
    if @user.save
      AppMailer.send_welcome_message(@user).deliver
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