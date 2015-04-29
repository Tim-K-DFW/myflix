require 'spec_helper'

describe SessionsController do
  
  context 'with authenticated user' do
    before { set_up_session }
    
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
  end   # with authenticated user

  context 'without authenticated user' do
    before { Fabricate(:user) }
    
    describe 'GET destroy' do
      it 'redirects to register path' do
        get 'destroy'
        expect(response).to redirect_to register_path
      end
    end

    describe 'POST create' do
      it 'finds user by params email if that user exists' do
        post 'create', email: User.first.email
        expect(assigns(:user)).to eq(User.first)
      end

      context 'with correct credentials' do
        before { post 'create', email: User.first.email, password: 'password' }

        it 'sets session to user id if user found and password matches' do
          expect(session[:user_id]).to eq(User.first.id)
        end

        it 'redirects to home if user found and password matches' do
          expect(response).to redirect_to home_path
        end
      end

      it 'redirects to login if user not found' do
        post 'create', email: 'random_email@email.com'
        expect(response).to redirect_to login_path
      end

      it 'redirects to login if user found but password does not match' do
        post 'create', email: User.first.email, password: 'wrong password'
        expect(response).to redirect_to login_path
      end
    end
  end # without authenticated user

  context 'with blocked user account' do
    before do
      Fabricate(:user, locked: true)
      post 'create', email: User.first.email, password: 'password'            
    end

    it 'does not set up session to user id' do
      expect(session[:user_id]).to be_blank
    end

    it 'sets flash error' do
      expect(flash[:danger]).to match(/locked/)
    end

    it 'redirects to register path' do
      expect(response).to redirect_to(register_path)
    end
  end
end
