require 'spec_helper'

describe UsersController do
  before { stub_out_stripe_wrapper }
  after { ActionMailer::Base.deliveries.clear }

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

    context 'user personal data is valid and card is valid' do
      before { post 'create', user: Fabricate.attributes_for(:user) }
      
      it 'sets up session' do
        expect(session[:user_id]).to eq(User.last.id)
      end

      it 'redirects to home' do
        expect(response).to redirect_to home_path
      end

      it 'creates new User record' do
        expect(User.all.size).to eq(1)
      end

      it 'charges users credit card' do
        expect(StripeWrapper::Charge).to receive(:create)
        post 'create', user: Fabricate.attributes_for(:user)
      end
    end

    context 'user personal data is invalid' do
      before { post 'create', user: {username: 'Pete'} }

      it 'does not attempt to charge users credit card' do
        expect(StripeWrapper::Charge).not_to receive(:create)
        post 'create', user: {username: 'Pete'}
      end

      it 'does not create new User record' do
        expect(User.all.count).to eq(0)
      end

      it 'shows error message' do
        expect(flash[:danger]).to eq('There was a problem with your input. Please fix it.')
      end

      it 'renders new template' do
        expect(response).to render_template(:new)
      end
    end

    context 'user personal data is valid but card declined' do
      let(:stub_respnose) { double(successful?: false, error_message: 'fake message') }
      before do
        allow(StripeWrapper::Charge).to receive(:create).and_return(stub_respnose)
        post :create, user: Fabricate.attributes_for(:user)
      end

      it 'show card declined error message' do
        expect(flash[:danger]).to match(/card has been declined/)
      end

      it 'renders new template' do
        expect(response).to render_template(:new)
      end

      it 'attempts to charge card' do
        expect(StripeWrapper::Charge).to receive(:create)
        post :create, user: Fabricate.attributes_for(:user)
      end

      it 'does not create new User record' do
        expect(User.all.count).to eq(0)
      end

      it 'does not send welcome email' do
        expect(ActionMailer::Base.deliveries).to be_empty
      end
    end # context 'user personal data valid but card declined'

    context 'sending welcome email' do
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

    context 'this user was invited' do
      let!(:pete) { Fabricate(:user) }
      let!(:jimmy) { Fabricate.attributes_for(:user, username: 'Jimmy34') }
      let!(:invitation){ Fabricate(:invitation, user: pete, friend_name: jimmy[:username], friend_email: jimmy[:email], token: 'fake_token') }
      before { post :create, user: jimmy, invitation_token: invitation.token }

      it 'destroys invitation record' do
        expect(Invitation.all.count).to eq(0)
      end

      it 'creates relation where the new user follows inviter' do
        jimmy = User.last
        expect(jimmy.following_relations.first.leader).to eq(pete)
        expect(pete.leading_relations.first.follower).to eq(jimmy)
      end

      it 'creates relation where inviter follows the new user' do
        jimmy = User.last
        expect(pete.following_relations.first.leader).to eq(jimmy)
        expect(jimmy.leading_relations.first.follower).to eq(pete)
      end
    end # this user was invited
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
    before { pete.generate_token }

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
      pete.generate_token
      post :reset_password, token: pete.token, password: '999'
      pete.reload
      expect(assigns(:user)).to eq(pete)
    end

    context 'with valid token' do
      before do
        pete.generate_token
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