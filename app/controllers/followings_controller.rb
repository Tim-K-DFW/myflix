class FollowingsController < ApplicationController
  def index
    @following_relations = current_user.following_relations
  end

  def create
    leader = User.find(params[:id])
    Following.create(leader: leader, follower: current_user) if current_user.can_follow?(leader)
    redirect_to people_path
  end

  def destroy
    @relation = Following.find(params[:id])
    @relation.destroy if current_user == @relation.follower
    redirect_to people_path
  end
end