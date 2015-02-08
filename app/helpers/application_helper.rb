module ApplicationHelper
  def custom_form_for(record, options = {}, &proc)
    form_for(record, options.merge!({builder: CustomFormBuilder}), &proc)
  end

  def this_users_score(queue_item)
    review = queue_item.video.reviews.select{|review| review[:user_id] == current_user.id}.first
    review.blank? ? '0' : review.score
  end
end
