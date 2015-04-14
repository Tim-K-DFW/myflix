class VideoDecorator < Draper::Decorator
  delegate_all

  def rating_display
    reviews.any? ? "#{average_score}/5.0" : "N/A"
  end
end
