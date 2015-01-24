class ApplicationController < ActionController::Base
  protect_from_forgery
  helper_method :logged_in?, :current_user


  def logged_in?
    !!session[:user_id]
  end

  def current_user
    if logged_in?
      @user ||= User.find_by(id: session[:user_id])
    else
      nil
    end
  end
end
