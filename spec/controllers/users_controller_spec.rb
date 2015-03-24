require 'spec_helper'

describe UsersController do

  context 'with authenticated user' do
    before { set_up_session }

    describe 'GET new' do
      it 'redirects to home' do
        get 'new'
        expect(response).to redirect_to home_path
      end
    end
  end

  context 'without authenticated user' do
    describe 'GET new' do
      it 'creates a new instance of User' do
        get 'new', user: Fabricate.attributes_for(:user)
        expect(assigns(:user)).to be_instance_of(User)
      end
    end
  end

  describe 'POST create' do
    it 'passes all params to the new instance of User' do
        attributes = Fabricate.attributes_for(:user)
        post 'create', user: attributes
        expect(assigns(:user).username).to eq(attributes[:username])
        expect(assigns(:user).email).to eq(attributes[:email])
    end

    context 'new user is valid' do
      before { post 'create', user: Fabricate.attributes_for(:user) }
      
      it 'sets up session' do
        expect(session[:user_id]).to eq(User.last.id)
      end

      it 'redirects to home' do
        expect(response).to redirect_to home_path
      end
    end

    context 'new user is invalid' do
      before { post 'create', user: {username: 'Pete'} }

      it 'shows error message' do
        expect(flash[:danger]).to eq('There was a problem with your input. Please fix it.')
      end

      it 'renders new template' do
        expect(response).to render_template(:new)
      end
    end

    context 'sending welcome email' do
      after { ActionMailer::Base.deliveries.clear }

      it 'sends welcome message' do
        post 'create', user: Fabricate.attributes_for(:user)
        expect(ActionMailer::Base.deliveries).not_to be_empty
      end

      it 'sends welcome message to correct recepient' do
        attributes = Fabricate.attributes_for(:user)
        post 'create', user: attributes
        message = ActionMailer::Base.deliveries.last
        expect(message.to.first).to eq(attributes[:email])
      end

      it 'sends welcome message with correct text' do
        post 'create', user: Fabricate.attributes_for(:user)
        message = ActionMailer::Base.deliveries.last
        expect(message.body).to match(/still fake/)
      end
    end
  end

  describe 'GET show' do
    let(:pete) { Fabricate(:user, username: 'pete') }
    let(:jimmy) { Fabricate(:user, username: 'jimmy') }

    context 'with authenticated user' do
      before { set_up_session(jimmy) }

      it 'retreives correct user into instance variable' do
        get :show, id: pete.id
        expect(assigns(:user)).to eq(pete)
      end
    end

    context 'without authenticated user' do
      it_behaves_like 'require_login' do
        let(:action) {get :show, id: pete.id}
      end
    end # without authenticated user
  end # GET show

  describe 'POST send_reset_link' do
    after { ActionMailer::Base.deliveries.clear }

    it 'generates error message when submitted email address not found in database' do
      pete = Fabricate(:user, email: 'pete@pete.com')
      post :send_reset_link, user: { email: 'wrong@email.com' }
      expect(flash[:danger]).to eq('If you forgot your email address as well, you can register again.')
    end

    context 'when email address found in database' do
      let!(:pete) { Fabricate(:user) }
      before { post :send_reset_link, email: pete.email }

      it 'sends email to correct user' do
        expect(ActionMailer::Base.deliveries.last.to).to eq([pete.email])
      end

      it 'generates a token' do
        pete.reload
        expect(pete.token).not_to be_nil
      end

      it 'sends email with the token' do
        pete.reload
        message = ActionMailer::Base.deliveries.last.body
        expect(message).to include(pete.token)
      end

      it 'renders confirmation page' do
        expect(response).to render_template('confirm_password_reset')
      end
    end
  end

  describe 'GET enter_new_password' do
    let!(:pete) { Fabricate(:user) }
    before { pete.generate_reset_link }

    it 'finds user by token in the url' do
      get :enter_new_password, token: pete.token
      expect(assigns(:user)).to eq(pete)
    end

    it 'renders new password form if user found' do
      get :enter_new_password, token: pete.token
      expect(response).to render_template('new_password_entry')
    end

    it 'renders token expired page if user not found' do
      get :enter_new_password, token: 'wrong_token'
      expect(response).to render_template('invalid_token')
    end
  end

  describe 'POST reset_password' do
    let!(:pete) { Fabricate(:user) }
    let!(:old_password) { pete.password_digest }
    

    it 'finds correct user record by token' do
      pete.generate_reset_link
      post :reset_password, token: pete.token, password: '999'
      pete.reload
      expect(assigns(:user)).to eq(pete)
    end

    context 'with valid token' do
      before do
        pete.generate_reset_link
        post :reset_password, token: pete.token, password: '999'
        pete.reload
      end

      it 'updates password attribute' do
        new_password = pete.password_digest
        expect(new_password).not_to eq(old_password)
      end

      it 'clears token attribute' do
        expect(pete.token).to be_nil
      end

      it 'generates flash message' do
        expect(flash[:success]).to eq('You have successfully reset your password.')
      end

      it 'redirects to sign in page' do
        expect(response).to redirect_to(login_path)
      end
    end # with valid token

    context 'with invalid token' do
      it 'renders invalid token page' do
        post :reset_password, token: 'wrong token', password: '999'
        expect(response).to render_template('invalid_token')
      end
    end # with invalid token
  end
end