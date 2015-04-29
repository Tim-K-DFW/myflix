require 'spec_helper'

describe UserSignup do
  describe '#signup' do
    after { ActionMailer::Base.deliveries.clear }

    it 'returns self' do
      stub_out_stripe_wrapper
      signup_handle = UserSignup.new(Fabricate.build(:user))
      response = signup_handle.signup('fake_stripe_token')
      expect(response).to eq(signup_handle)
    end

    context 'with valid user personal info and valid card' do
      before { stub_out_stripe_wrapper }
      let(:attributes){ Fabricate.attributes_for(:user) }
      let(:signup_handle){ UserSignup.new(User.new(attributes)) }

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

      context 'handing invitation if token passed' do
        let!(:pete) { Fabricate(:user) }
        let!(:jimmy) { Fabricate(:user) }
        let!(:invitation){ Fabricate(:invitation, user: pete, friend_name: jimmy[:username], friend_email: jimmy[:email], token: 'fake_token') }

        before do
          signup_handle = UserSignup.new(jimmy)
          signup_handle.signup('fake_sripe_token', invitation.token)
        end

        it 'creates relation where the new user follows inviter' do
          expect(jimmy.following_relations.first.leader).to eq(pete)
          expect(pete.leading_relations.first.follower).to eq(jimmy)
        end

        it 'creates relation where inviter follows the new user' do
          expect(pete.following_relations.first.leader).to eq(jimmy)
          expect(jimmy.leading_relations.first.follower).to eq(pete)
        end

        it 'destroys invitation record' do
          expect(Invitation.all.count).to eq(0)
        end
      end # context handling invitation if token passed

      it 'sets @status to :success' do
        signup_handle.signup('fake_sripe_token')
        expect(signup_handle.instance_variable_get(:@status)).to eq(:success)
      end
    end # context 'with valid user personal info and valid card'

    context 'with invalid user personal info' do
      let(:signup_handle){ UserSignup.new(User.new(username: 'Pete')) }

      it 'does not attempt to charge users credit card' do
        expect(StripeWrapper::Charge).not_to receive(:create)
        signup_handle.signup('fake_sripe_token')
      end

      it 'sets @error_message' do
        signup_handle.signup('fake_sripe_token')
        expect(signup_handle.error_message).to eq('There was a problem with your input. Please fix it.')
      end

      it_behaves_like 'doesnt_create_new_user'
    end # context with invalid user personal info

    context 'with valid user personal info and declined card' do
      let(:signup_handle){ UserSignup.new(Fabricate.build(:user)) }
      before do
        stub_out_stripe_wrapper(:failure)
        signup_handle.signup('fake_sripe_token')
      end

      it 'attempts to charge card' do
        expect(StripeWrapper::Charge).to receive(:create)
        signup_handle.signup('fake_sripe_token')
      end

      it 'sets @error_message' do
        expect(signup_handle.error_message).to match(/problem with your payment/)
      end

      it_behaves_like 'doesnt_create_new_user'
    end # context 'with valid user info and declined card
  end # #signup  
end
