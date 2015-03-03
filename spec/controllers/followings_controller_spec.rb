require 'spec_helper'

describe FollowingsController do

  describe 'GET index' do
    it_behaves_like 'require_login' do
      let(:action) { get :index }
    end

    it 'gets all following relations into instance variable' do
      alice = Fabricate(:user)
      pete = Fabricate(:user)
      jimmy = Fabricate(:user)
      set_up_session(pete)
      f1 = Following.create(leader: alice, follower: pete)
      f2 = Following.create(leader: jimmy, follower: pete)
      get :index
      expect(assigns(:following_relations)).to match_array([f1, f2])
    end
  end

  describe 'DELETE destroy' do
    it 'deletes following relation' do
      alice = Fabricate(:user)
      pete = Fabricate(:user)
      jimmy = Fabricate(:user)
      set_up_session(pete)
      f1 = Following.create(leader: alice, follower: pete)
      f2 = Following.create(leader: jimmy, follower: pete)
      delete :destroy, id: f1.id
      expect(pete.following_relations.count).to eq(1)
    end

    it 'does not delete and redirects to people if user is not the follower' do
      alice = Fabricate(:user)
      pete = Fabricate(:user)
      jimmy = Fabricate(:user)
      set_up_session(jimmy)
      f1 = Following.create(leader: alice, follower: pete)
      f2 = Following.create(leader: jimmy, follower: pete)
      delete :destroy, id: f1.id
      expect(pete.following_relations.count).to eq(2)
      expect(response).to redirect_to(people_path)
    end
  end

  describe 'POST create' do
    it_behaves_like 'require_login' do
      let(:action) { post :create }
    end

    it 'creates a correct Followign object' do
      alice = Fabricate(:user)
      pete = Fabricate(:user)
      set_up_session(pete)
      post :create, id: alice.id
      expect(pete.following_relations.first.leader).to eq(alice)     
    end

    it 'does not do anything if the person is already being followed' do
      alice = Fabricate(:user)
      pete = Fabricate(:user)
      set_up_session(pete)
      Following.create(leader: alice, follower: pete)
      post :create, id: alice.id
      expect(pete.following_relations.count).to eq(1)
    end
  end
end