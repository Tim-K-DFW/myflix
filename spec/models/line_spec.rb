require 'spec_helper'

describe Line do
  it { should belong_to :user }
  it { should belong_to :video }
  # it { should validate_uniqueness_of :video_id }
  it { should validate_uniqueness_of :priority }

  it 'returns rating for given user\'s review if rating exists' do
    video = Fabricate(:video)
    user = Fabricate(:user)
    review = Fabricate(:review, author: user, video: video, score: 4)
    item = Line.create(video: video, user: user)
    expect(item.score).to eq(4)
  end

  it 'returns nil for user\'s review if rating does not exist' do
    video = Fabricate(:video)
    user = Fabricate(:user)
    item = Line.create(video: video, user: user)
    expect(item.score).to be_blank
  end
end