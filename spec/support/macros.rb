def set_up_session
  user = Fabricate(:user)
  session[:user_id] = user.id
end

def current_user
  User.find(session[:user_id])
end

def clear_session
  session[:user_id] = nil
end