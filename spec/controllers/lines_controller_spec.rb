require 'spec_helper'

describe LinesController do
  
  let! (:user) { Fabricate(:user) }
  before { session[:user_id] = user.id }
  let! (:video1) { Fabricate(:video) }
  let! (:video2) { Fabricate(:video) }
  let! (:video3) { Fabricate(:video) }
  

  describe 'GET index' do
    it 'grabs user\'s queue into an instance variable' do
      line1 = Line.create(video: video1, user: user, priority: 1)
      line2 = Line.create(video: video2, user: user, priority: 2)
      get :index
      expect(assigns(:queue)).to match_array([line1, line2])
    end
  end

  describe 'POST create' do
    it 'finds video based on param' do
      post :create, id: video3.id
      expect(assigns(:video)).to eq(video3)
    end

    context 'when the video is not in the queue' do
      it 'creates new line entry' do
        post :create, id: video3.id
        expect(assigns(:line)).to be_instance_of(Line)
      end

      it 'adds the video to the queue bottom' do
        line1 = Line.create(video: video1, user: user, priority: 1)
        line2 = Line.create(video: video2, user: user, priority: 2)
        post :create, id: video3.id
        expect(assigns(:line).priority).to eq(3)
      end
    end # context
   
    it 'redirects to queue index page' do
      post :create, id: video3.id
      expect(response).to redirect_to show_queue_path
    end
  end

  describe 'DELETE destroy' do
   
    let! (:line1) { Line.create(video: video1, user: user, priority: 1) }
    let! (:line2) { Line.create(video: video2, user: user, priority: 2) }
    let! (:line3) { Line.create(video: video3, user: user, priority: 3) }

    it 'removes the item from queue' do
      delete :destroy, id: Line.where(video: video3).first.id
      expect(Line.all.count).to eq(2)
    end

    it 'updates priority numbers of remaining items' do
      delete :destroy, id: line1.id
      expect(Line.find(line2.id).priority).to eq(1)
      expect(Line.find(line3.id).priority).to eq(2)
    end

    it 'redirects to queue index page' do
      delete :destroy, id: line1.id
      expect(response).to redirect_to show_queue_path
    end
  end

  describe 'POST update' do
    
    
    it 'redirects to queue display page' do
      Line.update_queue(user.id, {1 => '3'})
      expect(response).to redirect_to show_queue_path
    end



  end

end