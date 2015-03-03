class FollowingsController < ApplicationController
  def index
    @following_relations = current_user.following_relations
  end

  def create
    leader = User.find(params[:id])
    Following.create(leader: leader, follower: current_user) if Following.where(follower: current_user, leader: leader).blank?
    redirect_to user_path(params[:id])
  end

  def destroy
    @relation = Following.find(params[:id])
    @relation.destroy if current_user == @relation.follower
    redirect_to people_path
  end
end