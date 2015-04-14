require 'spec_helper'

describe UserSignup do

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
        expect(flash[:danger]).to match(/problem with your payment/)
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
