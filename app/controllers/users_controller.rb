class UsersController < ApplicationController
  skip_before_action :require_login, only: [:new, :create, :request_reset, :send_reset_link, :enter_new_password, :reset_password]

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
    user = User.where(email: params[:email]).first
    if user
      scheme = request.env['rack.url_scheme']
      host = request.env['HTTP_HOST']
      link = user.generate_reset_link(scheme, host)
      AppMailer.send_password_reset_link(user, link).deliver
      render 'confirm_password_reset'
    else
      flash[:danger] = 'If you forgot your email address as well, you can register again.'
      render 'request_reset'
    end
  end

  def enter_new_password
    @user = User.where(token: params[:token]).first
    if @user
      render 'new_password_entry'
    else
      render 'invalid_token'
    end
  end

  def reset_password
    @user = User.where(token: params[:token]).first
    @user.update(password: params[:password])
    @user.update(token: nil)
    flash[:info] = 'You have successfully reset your password.'
    redirect_to login_path
  end

  private

  def get_params
    params.require(:user).permit!
  end
end