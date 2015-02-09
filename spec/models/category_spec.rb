require 'spec_helper'

describe Category do
  it { should validate_presence_of(:name) }
  it { should have_many(:videos)}

  describe '#recent_videos' do
    let!(:cat1) { Category.create(name: 'Comedy') }
    let!(:video1) { Video.create(title: 'Futurama', description: 'in the future', created_at: 10.day.ago, category: cat1) }
    let!(:video2) { Video.create(title: 'Future weapons', description: 'vintage', created_at: 1.day.ago, category: cat1) }
    let!(:video3) { Video.create(title: 'Futurama', description: 'in the future', created_at: 5.day.ago, category: cat1) }

    it 'returns 6 most recent videos when there are 6 and more total' do
      video4 = Video.create(title: 'Futurama', description: 'in the future', created_at: 10.day.ago, category: cat1)
      video5 = Video.create(title: 'Future weapons', description: 'vintage', created_at: 27.day.ago, category: cat1)
      video6 = Video.create(title: 'Futurama', description: 'in the future', created_at: 4.day.ago, category: cat1)
      video7 = Video.create(title: 'Futurama', description: 'in the future', created_at: 57.day.ago, category: cat1)
      video8 = Video.create(title: 'Future weapons', description: 'vintage', created_at: 80.day.ago, category: cat1)
      video9 = Video.create(title: 'Futurama', description: 'in the future', created_at: 50.day.ago, category: cat1)
      results = cat1.recent_videos
      expect(results).to match_array([video2, video6, video3, video4, video1, video5])
    end

    it 'returns all videos when there are less than 6 total' do
      results = cat1.recent_videos
      expect(results).to match_array([video1, video2, video3])
    end

    it 'returns blank array when there are no videos' do
      Video.destroy_all
      results = cat1.recent_videos
      expect(results).to match_array([])
    end

    it 'produces retun in reverse chronological order' do
      results = cat1.recent_videos
      expect(results).to eq([video2, video3, video1])
    end
  end
end