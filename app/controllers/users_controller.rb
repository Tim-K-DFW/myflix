class UsersController < ApplicationController
  skip_before_action :require_login, only: [:new, :create, :request_reset, :send_reset_link]

  def new     # will create a blank one for the form helper
    redirect_to home_path if logged_in?
    @user = User.new
  end

  def show
    @user = User.find(params[:id])
  end

  def create
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

  def request_reset
  end

  def send_reset_link
    @user = User.where(email: params[:user][:email]).first
    if @user
      @link = @user.generate_reset_link
      AppMailer.send_password_reset_link(@user).deliver
      render 'confirm_password_reset'
    else
      flash[:danger] = 'If you forgot your email address as well, you can register again.'
      render 'request_reset'
    end
  end

  private

  def get_params
    params.require(:user).permit!
  end
end