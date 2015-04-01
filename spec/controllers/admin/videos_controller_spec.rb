require 'spec_helper'

describe Admin::VideosController do
  describe 'GET new' do
    it 'assigns new instance of Video to @video' do
      set_up_admin_session
      get :new
      expect(assigns(:video)).to be_an_instance_of(Video)
      expect(assigns(:video)).to be_a_new_record
    end

    context 'not admin' do
      before do
        set_up_session
        get :new
      end

      it 'generates flash error' do
        expect(flash[:danger]).to be_present
      end

      it 'redirects anyone who is not admin to home path' do
        expect(response).to redirect_to(home_path)
      end
    end
  end
end