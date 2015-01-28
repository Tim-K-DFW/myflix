require 'spec_helper'

describe VideosController do

  context 'with authenticated user' do
    let! (:vid1) { Fabricate(:video) }
    let! (:vid2) { Fabricate(:video) }
    before { session[:user_id] = 1 }

    describe 'GET show' do
      it 'finds a video by id passed in param' do
        get 'show', id: vid1.id
        assigns(:video).should == vid1
      end

      it 'renders show template' do
        get :show, id: vid1.id
        response.should render_template :show
      end
    end

    describe 'POST search' do
      it 'assigns found videos to @videos' do
        post :search, search_term: vid1.title
        assigns(:videos).should == [vid1]
      end
      
      it 'renders search template' do
        post :search, search_term: 'uby'
        response.should render_template :search
      end
    end
  end
end