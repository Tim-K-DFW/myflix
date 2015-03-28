require 'spec_helper'

describe InvitationsController do
  before { set_up_session }

  describe 'GET new' do
    it 'creates a new instance of invitation' do
      get :new
      expect(assigns(:invitation)).to be_an_instance_of(Invitation)
      expect(assigns(:invitation)).to be_a_new_record
    end

    it_behaves_like 'require_login' do
      let(:action) { get :new }
    end
  end

  describe 'POST create' do
    after { ActionMailer::Base.deliveries.clear }

    context 'with valid input' do
      let!(:fake_params) { Fabricate.attributes_for(:invitation) }
      before { post :create, invitation: fake_params }

      it 'creates a new Invitation record' do
        expect(Invitation.all.count).to eq(1)
      end

      context 'it sends an email' do
        let!(:email) { ActionMailer::Base.deliveries.last }

        it 'to correct recipient' do
          expect(email.to).to eq([fake_params[:friend_email]])
        end

        it 'with correct user name' do
          expect(email.body).to include(current_user.username)
        end

        it 'with specified body' do
          expect(email.body).to include(fake_params[:message])
        end

        it 'with correct link' do
          expect(email.body).to include(assigns(:invitation).token)
        end
      end

      it 'displays success message' do
        expect(flash[:success]).to eq("Invitation to #{assigns(:invitation).friend_name} has been sent successfully.")
      end

      it 'redirects to home page' do
        expect(response).to redirect_to(home_path)
      end
    end # with valid input

    context 'when user tries to invite himself' do
      let!(:fake_params) { Fabricate.attributes_for(:invitation, friend_email: current_user.email) }
      before { post :create, invitation: fake_params }

      it 'does not create new Invitation record' do
        expect(Invitation.all.count).to eq(0)
      end

      it 'does not send an email' do
        expect(ActionMailer::Base.deliveries).to be_empty
      end

      it 'generates flash error message' do
        expect(flash[:danger]).to eq('You cannot send an invitation to yourself.')
      end

      it 'renders new page' do
        expect(response).to render_template('new')
      end
    end

    context 'with invalid input' do
      before { post :create, invitation: {friend_email: 'x', friend_name: 'x', message: 'x'} }

      it 'does not create new Invitation record' do
        expect(Invitation.all.count).to eq(0)
      end

      it 'does not send an email' do
        expect(ActionMailer::Base.deliveries).to be_empty
      end

      it 'generates flash error message' do
        expect(flash[:danger]).to eq('There was an error with your input.')
      end

      it 'renders new page' do
        expect(response).to render_template('new')
      end
    end # with invalid input
    
    it_behaves_like 'require_login' do
      let(:action) { post :create }
    end
  end

  describe 'GET accept' do
    let!(:invitation) { Fabricate(:invitation, user: current_user) }
    before { get :accept, token: invitation.token }

    context 'with valid link' do
      it 'pulls invitation record' do
        expect(assigns(:invitation)).to eq(invitation)
      end

      it 'creates a new user instance' do
        expect(assigns(:user)).to be_an_instance_of(User)
        expect(assigns(:user)).to be_a_new_record
      end

      it 'pre-fills user data based on invitation' do
        expect(assigns(:user).email).to eq(invitation.friend_email)
        expect(assigns(:user).username).to eq(invitation.friend_name)
      end

      it 'renders registragion page' do
        expect(response).to render_template('users/new')
      end
    end

    context 'with invalid link' do
      it 'renders error page' do
        get :accept, token: 'invalid'
        expect(response).to render_template('invalid_invitation')
      end
    end
  end # 'GET accept'
end