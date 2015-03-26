class InvitationsController < ApplicationController

  def new
    @invitation = Invitation.new
    @invitation.user = current_user
  end

  def create
    redirect_to home_path
  end

end
