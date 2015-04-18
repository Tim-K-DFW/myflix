class UserSignup
  attr_reader :error_message, :user

  def initialize(user)
    @user = user
  end

  def signup(stripe_token, invitation_token=nil)
    if @user.valid?
      charge = StripeWrapper::Customer.create(
        token: stripe_token,
        email: @user.email
      )
      if charge.successful?
        @user.save
        AppMailer.send_welcome_message(@user).deliver
        handle_invitation(invitation_token) if invitation_token
        @status = :success
        self
      else
        @status = :failed
        @error_message = "There was a problem with your payment: #{charge.error_message} Please try again."
        self
      end
    else
      @status = :failed
      @error_message = 'There was a problem with your input. Please fix it.'
      self
    end
  end

  def successful?
    @status == :success
  end

  def handle_invitation(invitation_token)
    invitation = Invitation.find_by_token(invitation_token)
    @user.follow(invitation.user)
    invitation.user.follow(@user)
    invitation.destroy
  end
end
