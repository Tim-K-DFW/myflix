class PagesController < ApplicationController
  skip_before_action :require_login, only: :front

  def front
    redirect_to home_path if logged_in?
  end
end