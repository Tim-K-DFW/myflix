require 'spec_helper'

describe Admin::VideosController do
  describe 'GET new' do
    it 'assigns new instance of Video to @video' do
      set_up_admin_session
      get :new
      expect(assigns(:video)).to be_an_instance_of(Video)
      expect(assigns(:video)).to be_a_new_record
    end

    it_behaves_like 'require_admin' do
      let(:action) { get :new }
    end
  end

  describe 'POST create' do
    context 'with valid input' do
      before do
        set_up_admin_session
        post :create, video: Fabricate.attributes_for(:video)
      end

      it 'creates a Video record' do
        expect(Video.all.count).to eq(1)
      end

      it 'generates success flash' do
        expect(flash[:success]).to be_present
      end

      it 'redirects to create new video path' do
        expect(response).to redirect_to new_admin_video_path
      end
    end

    context 'with invalid input' do
      before do
        set_up_admin_session
        post :create, video: { description: 'stupid video' }
      end

      it 'does not create a Video record' do
        expect(Video.all.count).to eq(0)
      end

      it 'generates an error flash' do
        expect(flash[:danger]).to be_present
      end

      it 'renders new page' do
        expect(response).to render_template :new
      end

      it 'creates @video variable' do
        expect(assigns(:video)).to be_an_instance_of(Video)
      end
    end

    it_behaves_like 'require_admin' do
      let(:action) { post :create }
    end
  end
end
