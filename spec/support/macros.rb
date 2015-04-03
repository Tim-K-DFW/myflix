def set_up_session(*user_arg)
  user = user_arg[0] || Fabricate(:user)
  session[:user_id] = user.id
end

def set_up_admin_session(*user_arg)
  user = user_arg[0] || Fabricate(:admin)
  session[:user_id] = user.id
end

def current_user
  User.find(session[:user_id])
end

def clear_session
  session[:user_id] = nil
end

def login(*user_arg)
  user = user_arg[0] || Fabricate(:user)
  visit '/'
  click_link 'Sign In'
  fill_in :email, with: user.email
  fill_in :password, with: user.password
  click_button 'Sign In'
end

def click_video_on_homepage(video)
  click_link("video_#{video.id}_link")
end

def reset_password_flow(user)
  visit '/login'
  click_link('Forgot password?')
  fill_in :email, with: user.email
  click_button 'Send Email'
  email = open_email(user.email)
  email.click_link('Reset your password')
  fill_in :password, with: '123'
  click_button('Reset Password')
end