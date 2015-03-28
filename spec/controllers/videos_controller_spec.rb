require 'spec_helper'

describe VideosController do
  let! (:vid1) { Fabricate(:video) }
  let! (:vid2) { Fabricate(:video) }
  before { set_up_session }

  describe 'GET index' do
    it_behaves_like 'require_login' do
      let(:action) { get :index}
    end
  end

  describe 'GET show' do
    it 'finds a video by id passed in param' do
      get 'show', id: vid1.id
      expect(assigns(:video)).to eq(vid1)
    end

    it_behaves_like 'require_login' do
      let(:action) { get :show, id: vid1.id }
    end
  end

  describe 'POST search' do
    it 'assigns found videos to @videos' do
      post :search, search_term: vid1.title
      expect(assigns(:videos)).to eq([vid1])
    end
    
    it_behaves_like 'require_login' do
      let(:action) { post :search, search_term: 'uby' }
    end
  end
end