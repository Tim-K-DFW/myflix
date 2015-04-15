require 'spec_helper'

describe UserSignup do
  before { stub_out_stripe_wrapper }

  describe '#signup' do
    it 'returns self' do
      user = User.new(Fabricate.attributes_for(:user))
      signup_handle = UserSignup.new(user)
      response = signup_handle.signup('fake_stripe_token')
      expect(response).to eq(signup_handle)
    end

    context 'with valid user personal data and valid card' do
      let(:attributes){ Fabricate.attributes_for(:user) }
      let(:user){ User.new(attributes) }
      let(:signup_handle){ UserSignup.new(user) }

      it 'charges users credit card' do
        expect(StripeWrapper::Charge).to receive(:create)
        signup_handle.signup('fake_sripe_token')
      end

      it 'creates new User record' do
        signup_handle.signup('fake_sripe_token')
        expect(User.all.size).to eq(1)
      end

      context 'sending welcome email' do
        before { signup_handle.signup('fake_sripe_token') }
        after { ActionMailer::Base.deliveries.clear }

        it 'sends welcome message' do
          expect(ActionMailer::Base.deliveries).not_to be_empty
        end

        it 'sends welcome message to correct recepient' do
          message = ActionMailer::Base.deliveries.last
          expect(message.to.first).to eq(attributes[:email])
        end

        it 'sends welcome message with correct text' do
          message = ActionMailer::Base.deliveries.last
          expect(message.body).to match(/still fake/)
        end
      end # context sending welcome email

      it 'calls #handle_invitation if token was present' do
        expect(signup_handle).to receive(:handle_invitation).with('fake_invitation_token')
        signup_handle.signup('fake_sripe_token', 'fake_invitation_token')
      end

      it 'sets @status to :success' do
        signup_handle.signup('fake_sripe_token')
        expect(signup_handle.instance_variable_get(:@status)).to eq(:success)
      end
    end

    context 'with invalid user personal data' do
      it 'does not attempt to charge users credit card' do
        expect(StripeWrapper::Charge).not_to receive(:create)
        post 'create', user: {username: 'Pete'}
      end

      it 'does not create new User record' do
        expect(User.all.count).to eq(0)
      end

      it 'sets @status to :failure'

      it 'sets @error_message' do
        expect(flash[:danger]).to eq('There was a problem with your input. Please fix it.')
      end
    end

    context 'with valid user personal info and declined card' do
      let(:stub_respnose) { double(successful?: false, error_message: 'fake message') }

      before do
        allow(StripeWrapper::Charge).to receive(:create).and_return(stub_respnose)
        post :create, user: Fabricate.attributes_for(:user)
      end

      it 'attempts to charge card' do
        expect(StripeWrapper::Charge).to receive(:create)
        post :create, user: Fabricate.attributes_for(:user)
      end

      it 'sets @status to :failure'

      it 'sets @error_message' do
        expect(flash[:danger]).to eq('There was a problem with your input. Please fix it.')
      end

      it 'does not create new User record' do
        expect(User.all.count).to eq(0)
      end

      it 'does not send welcome email' do
        expect(ActionMailer::Base.deliveries).to be_empty
      end
    end # context 'user personal data valid but card declined'
  
    
  end

  describe '#handle_invitation' do
    let!(:pete) { Fabricate(:user) }
    let!(:jimmy) { Fabricate.attributes_for(:user, username: 'Jimmy34') }
    let!(:invitation){ Fabricate(:invitation, user: pete, friend_name: jimmy[:username], friend_email: jimmy[:email], token: 'fake_token') }
    before { post :create, user: jimmy, invitation_token: invitation.token }

    it 'finds correcnt invitation record'

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

    it 'destroys invitation record' do
      expect(Invitation.all.count).to eq(0)
    end
  end # #hanle_invitation
end
