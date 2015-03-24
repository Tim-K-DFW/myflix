class AppMailer < ActionMailer::Base
  def send_welcome_message(user)
    mail from: 'info@myflix.com', to: user.email, subject: 'Welcome to Myflix!'
  end

  def send_password_reset_link(user, link)
    @reset_link = link
    @user = user
    mail from: 'info@myflix.com,', to: user.email, subject: 'MyFlix password reset'
  end
end