require 'spec_helper'

describe SessionsController do
  
  let! (:user1) { Fabricate(:user) }
  let! (:user2) { Fabricate(:user) }

  context 'with authenticated user' do
    before { session[:user_id] = User.first.id }
    
    describe 'GET new' do
      it 'redirects to home' do
        get 'new'
        expect(response).to redirect_to home_path
      end
    end

    describe 'GET destroy' do
      before { get 'destroy' }

      it 'cleans up session' do
        expect(session[:user_id]).to eq(nil)
      end
      
      it 'sets flash notice' do
        expect(flash[:info]).to eq('You have logged out.')
      end
      
      it 'redirects to root' do
        expect(response).to redirect_to root_path
      end
    end
  end

  context 'without authenticated user' do
    before { session[:user_id] = nil } 
    
    describe 'GET destroy' do
      it 'redirects to register path' do
        get 'destroy'
        expect(response).to redirect_to register_path
      end
    end
  end

  describe 'POST create' do
    it 'finds user by params email if that user exists' do
      post 'create', email: User.first.email
      expect(assigns(:user)).to eq(User.first)
    end

    it 'redirects to login if user not found' do
      post 'create', email: 'random_email@email.com'
      expect(response).to redirect_to login_path
    end

    it 'sets session to user id if user found and password matches' do
      post 'create', email: User.first.email, password: 'password'
      expect(session[:user_id]).to eq(User.first.id)
    end

    it 'redirects to home if user found and password matches' do
      post 'create', email: User.first.email, password: 'password'
      expect(response).to redirect_to home_path
    end

    it 'redirects to login if user found but password does not match' do
      post 'create', email: User.first.email, password: 'wrong password'
      expect(response).to redirect_to login_path
    end
  end
end