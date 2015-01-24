require 'spec_helper'

describe Category do

  it { should validate_presence_of(:name) }
  it { should have_many(:videos)}

  describe '#recent_videos' do
    it 'returns 6 most recent videos when there are 6 and more total' do

      cat1 = Category.create(name: 'Comedy')
      video1 = Video.create(title: 'Futurama', description: 'in the future', created_at: 1.day.ago, category: cat1)
      video2 = Video.create(title: 'Future weapons', description: 'vintage', created_at: 100.day.ago, category: cat1)
      video3 = Video.create(title: 'Futurama', description: 'in the future', created_at: 30.day.ago, category: cat1)
      video4 = Video.create(title: 'Futurama', description: 'in the future', created_at: 10.day.ago, category: cat1)
      video5 = Video.create(title: 'Future weapons', description: 'vintage', created_at: 27.day.ago, category: cat1)
      video6 = Video.create(title: 'Futurama', description: 'in the future', created_at: 4.day.ago, category: cat1)
      video7 = Video.create(title: 'Futurama', description: 'in the future', created_at: 57.day.ago, category: cat1)
      video8 = Video.create(title: 'Future weapons', description: 'vintage', created_at: 80.day.ago, category: cat1)
      video9 = Video.create(title: 'Futurama', description: 'in the future', created_at: 50.day.ago, category: cat1)

      results = cat1.recent_videos
      expect(results).to match_array([video1, video3, video4, video9, video5, video6])
    end

    it 'returns all videos when there are less than 6 total' do
        cat1 = Category.create(name: 'Comedy')
      video1 = Video.create(title: 'Futurama', description: 'in the future', created_at: 1.day.ago, category: cat1)
      video2 = Video.create(title: 'Future weapons', description: 'vintage', created_at: 2.day.ago, category: cat1)
      video3 = Video.create(title: 'Futurama', description: 'in the future', created_at: 3.day.ago, category: cat1)

      results = cat1.recent_videos
      expect(results).to match_array([video1, video2, video3])
    end

    it 'returns blank array when there are no videos' do
      cat1 = Category.create(name: 'Comedy')
      results = cat1.recent_videos
      expect(results).to match_array([])
    end

    it 'produces retun in reverse chronological order' do
      cat1 = Category.create(name: 'Comedy')
      Video.all.destroy_all
      video1 = Video.create(title: 'Futurama', description: 'in the future', created_at: 10.day.ago, category: cat1)
      video2 = Video.create(title: 'Future weapons', description: 'vintage', created_at: 1.day.ago, category: cat1)
      video3 = Video.create(title: 'Futurama', description: 'in the future', created_at: 5.day.ago, category: cat1)
      results = cat1.recent_videos
      expect(results).to eq([video2, video3, video1])
    end

  end

end