class SessionsController < ApplicationController

  def landing     # if logged in, with redirect to homepage, otherwise signup or login
  end

  def new
  end

  def create
    user = User.find_by(email: params[:email])
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect_to home_path
    else
      flash[:danger] = 'There was an error with your email or password. Try again or register.'
      render 'new'
    end
  end

  def destroy
    session[:user_id] = nil
    flash[:info] = 'You have logged out'
    redirect_to root_path
  end

end