require 'spec_helper'

describe LinesController do
  
  let! (:user) { Fabricate(:user) }
  before { session[:user_id] = user.id }
  let! (:video1) { Fabricate(:video) }
  let! (:video2) { Fabricate(:video) }
  let! (:queue) { Line.create(videos: [video1, video2], user: user) }

  describe 'GET show' do
    it 'grabs user\'s queue into an instance variable' do
      get :show
      expect(assigns(:queue)).to eq(queue)
    end

  end

  describe 'POST update' do

  end

end