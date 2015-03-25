class AppMailer < ActionMailer::Base
  def send_welcome_message(user)
    mail from: 'info@myflix.com', to: user.email, subject: 'Welcome to Myflix!'
  end

  def send_password_reset_link(user, token)
    @token = token
    mail from: 'info@myflix.com,', to: user.email, subject: 'MyFlix password reset'
  end
end