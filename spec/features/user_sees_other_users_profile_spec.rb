require 'spec_helper'

feature 'user sees other users profile' do
  given!(:jimmy) { Fabricate(:user) }
  given!(:pete) { Fabricate(:user, username: 'Pete') }
  given!(:comedies) { Fabricate(:category, name: 'Comedies') }
  given!(:futurama) { Fabricate(:video, title: 'Futurama', category: comedies) }
  given!(:blackhawk) { Fabricate(:video, title: 'Blackhawk Down', category: comedies) }
  given!(:review1) { Fabricate(:review, video: futurama, author: pete) }
  given!(:review2) { Fabricate(:review, video: blackhawk, author: pete) }

  background do
    Line.create(user: pete, video: futurama, priority: 1)
    Line.create(user: pete, video: blackhawk, priority: 2)
    login(jimmy)
    click_video_on_homepage(futurama)
    # click_link('Pete')
  end

  scenario 'user sees number of videos in queue' do
    binding.pry
    expect(page).to have_content("video collections (#{pete.lines.count})")
  end

  scenario 'user sees the queue' do
    expect(page).to have_content('Futurama')
    expect(page).to have_content('Blackhawk Down')
    expect(page).to have_content(futurama.category.name)
    expect(page).to have_content(blackhawk.category.name)
  end

  scenario 'user sees number of reviews' do
    expect(page).to have_content("#{pete.username}'s Reviews (#{pete.reviews.count})")    
  end

  scenario 'user sees reviews' do
    expect(page).to have_content(review1.body)
    expect(page).to have_content(review2.body)
  end
end