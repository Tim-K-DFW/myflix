require 'spec_helper'

describe Line do
  it { should belong_to :user }
  it { should belong_to :video }
  # it { should validate_uniqueness_of :video_id }
  # it { should validate_uniqueness_of :priority }

  let!(:user) { Fabricate(:user) }
  let!(:video1) { Fabricate(:video) }
  let!(:video2) { Fabricate(:video) }
  let!(:video3) { Fabricate(:video) }
  let!(:video4) { Fabricate(:video) }
  let!(:video5) { Fabricate(:video) }
  let!(:line1) { Line.create(video: video1, priority: 1, user: user) }
  let!(:line2) { Line.create(video: video2, priority: 2, user: user) }
  let!(:line3) { Line.create(video: video3, priority: 3, user: user) }
  let!(:line4) { Line.create(video: video4, priority: 4, user: user) }
  let!(:line5) { Line.create(video: video5, priority: 5, user: user) }

  describe '#score' do
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

  describe '.update_queue' do

    it 'updates queue if all inputs are integers and unique and no swap' do
      Line.update_queue(user.id, [{id: line1.id, new_position: 6}, {id: line2.id, new_position: 7}])
      expect(line1.reload.priority).to eq(4)
      expect(line2.reload.priority).to eq(5)
      expect(line3.reload.priority).to eq(1)
      expect(line4.reload.priority).to eq(2)
      expect(line5.reload.priority).to eq(3)
    end

    it 'does not update queue if at least one input is not an integer' do
      Line.update_queue(user.id, {line1.id => 'asd', line2.id => '6'})
      expect(line1.reload.priority).to eq(1)
      expect(line2.reload.priority).to eq(2)
      expect(line3.reload.priority).to eq(3)
      expect(line4.reload.priority).to eq(4)
      expect(line5.reload.priority).to eq(5)
    end
  
    it 'updates queue with position swap spelled out' do
      Line.update_queue(user.id, [{id: line1.id, new_position: 4}, {id: line4.id, new_position: 1}])
      expect(line1.reload.priority).to eq(4)
      expect(line2.reload.priority).to eq(2)
      expect(line3.reload.priority).to eq(3)
      expect(line4.reload.priority).to eq(1)
      expect(line5.reload.priority).to eq(5)
    end

  end
end