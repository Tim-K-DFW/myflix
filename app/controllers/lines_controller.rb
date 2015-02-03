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
    priority = @item.priority
    @item.destroy
    update_priorities
    redirect_to show_queue_path
  end


end