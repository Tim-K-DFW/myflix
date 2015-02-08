class LinesController < ApplicationController

  def index      # shows queue, including controls to update it
    @queue = current_user.lines.sort_by { |k| k[:priority] }
  end

  def create
    @video = Video.find(params[:id])
    @line = Line.create(user: current_user, video: @video, priority: current_user.lines.count + 1)
    redirect_to show_queue_path
  end

  def destroy
    @item = Line.find(params[:id])
    @item.destroy if @item.user.id == current_user.id
    current_user.bump_up_queue
    redirect_to show_queue_path
  end

  def update
    Line.update_queue(current_user.id, {new_positions: params[:new_positions], new_ratings: params[:new_ratings]})
    redirect_to show_queue_path
  end

end