def set_up_session(*user_arg)
  user = user_arg[0] || Fabricate(:user)
  session[:user_id] = user.id
end

def current_user
  User.find(session[:user_id])
end

def clear_session
  session[:user_id] = nil
end

def feature_login(*user_arg)
  user = user_arg[0] || Fabricate(:user)
  visit '/'
  click_link 'Sign In'
  fill_in :email, with: user.email
  fill_in :password, with: user.password
  click_button 'Sign In'
end