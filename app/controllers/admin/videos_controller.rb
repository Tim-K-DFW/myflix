class Admin::VideosController < ApplicationController
  before_action :require_admin

  def new
    @video = Video.new
  end

  def create
    @video = Video.new(video_params)
    if @video.valid?
      @video.small_cover_url = @video.small_cover_upload.filename
      @video.large_cover_url = @video.large_cover_upload.filename
      @video.save
      flash[:success] = 'Video was added successfully.'
      redirect_to new_admin_video_path
    else
      flash[:danger] = 'There was an error. Try again.'
      render :new
    end
  end

  private

  def video_params
    params.require(:video).permit(:category_id, :description, :title, :small_cover_upload, :large_cover_upload, :url)
  end
end
