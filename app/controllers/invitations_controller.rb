class InvitationsController < ApplicationController
  skip_before_action :require_login, only: :accept

  def new
    @invitation = Invitation.new
    @invitation.user = current_user
  end

  def create
    if params[:invitation][:friend_email] == current_user.email
      flash[:danger] = 'You cannot send an invitation to yourself.'
      render 'new'
    else
      @invitation = Invitation.new(get_params)
      @invitation.user = current_user
      if @invitation.save
        @invitation.generate_token
        AppMailer.send_invitation(@invitation).deliver
        flash[:success] = "Invitation to #{@invitation.friend_name} has been sent successfully."
        redirect_to home_path
      else
        flash[:danger] = 'There was an error with your input.'
        render 'new'
      end
    end
  end

  def accept
    @invitation = Invitation.find_by_token(params[:token])
    if @invitation
      @user = User.new
      @user.email = @invitation.friend_email
      @user.username = @invitation.friend_name
      render 'users/new'
    else
      render 'invalid_invitation'
    end
  end

  private

  def get_params
    params.require(:invitation).permit(:friend_name, :friend_email, :message)
  end
end
