class ApplicationController < ActionController::Base
  protect_from_forgery
  helper_method :logged_in?, :current_user, :require_admin
  before_action :require_login


  def logged_in?
    !!session[:user_id]
  end

  def current_user
    if logged_in?
      @current_user ||= User.find_by(id: session[:user_id])
    else
      nil
    end
  end

  def require_login
    if !logged_in?
      flash[:danger] = 'This section is for members only. Please register to become one.'
      redirect_to register_path
    end
  end

  def require_admin
    if !current_user.admin?
      flash[:danger] = 'You need admin access to do this.'
      redirect_to home_path
    end
  end
end
