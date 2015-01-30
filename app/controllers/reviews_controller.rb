class ReviewsController < ApplicationController

  def create
    review_params = params.require(:review).permit(:body, :score)
    @review = Review.new(review_params)
    @review.author = current_user
    @video = Video.find(params[:video_id])
    @review.video = @video
    if @review.save
      flash[:info] = 'Your review was added!'
      redirect_to video_path(@video)
    else
      render 'videos/show'
    end
    
  end
end