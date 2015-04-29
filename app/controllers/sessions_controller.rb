class SessionsController < ApplicationController
  skip_before_action :require_login, only: [:new, :create]

  def new
    redirect_to home_path if logged_in?
  end

  def create
    @user = User.find_by(email: params[:email])
    if @user && @user.authenticate(params[:password])
      if @user.locked?
        flash[:danger] = 'Your account has been locked. Please contact admin at restore@myflix.com or register again.'
        redirect_to register_path
      else
        session[:user_id] = @user.id
        redirect_to home_path
      end
    else
      flash[:danger] = 'Invalid email or password.'
      redirect_to login_path
    end
  end

  def destroy
    session[:user_id] = nil
    flash[:info] = 'You have logged out.'
    redirect_to root_path
  end

end