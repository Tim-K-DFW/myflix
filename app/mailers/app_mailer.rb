class AppMailer < ActionMailer::Base
  def send_welcome_message(user)
    mail from: 'info@myflix.com', to: user.email, subject: 'Welcome to Myflix!'
  end
end