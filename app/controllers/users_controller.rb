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
    if @user.valid?

      token = params[:stripeToken]
      charge = StripeWrapper::Charge.create(
        amount: 999,
        token: token,
        description: "sign-up fee for #{params[:user][:email]}"
      )
      if !charge.successful?
        flash[:danger] = "Your card has been declined: #{charge.error_message} Please try again."
        render 'new' and return
      end

      @user.save
      AppMailer.send_welcome_message(@user).deliver
      handle_invitation if params[:invitation_token]
      flash[:success] = 'You have successfully signed up. Welcome to MyFlix, and enjoy the movies!'
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
      token = user.generate_token
      AppMailer.send_password_reset_link(user, token).deliver
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
    if @user
      @user.update(password: params[:password])
      @user.update(token: nil)
      flash[:success] = 'You have successfully reset your password.'
      redirect_to login_path
    else
      render 'invalid_token'
    end
  end

  private

  def get_params
    params.require(:user).permit(:email, :password, :username)
  end

  def handle_invitation
    invitation = Invitation.find_by_token(params[:invitation_token])
    @user.follow(invitation.user)
    invitation.user.follow(@user)
    invitation.destroy
  end
end
