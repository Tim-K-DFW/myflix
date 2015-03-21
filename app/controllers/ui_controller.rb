class UiController < ApplicationController
  before_filter do
    redirect_to :root if Rails.env.production?
  end

  skip_before_action :require_login

  layout "application"

  def index
  end
end
