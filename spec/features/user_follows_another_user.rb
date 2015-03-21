require 'spec_helper'

feature 'user sees other users profile' do
  given!(:jimmy) { Fabricate(:user) }
  given!(:pete) { Fabricate(:user, username: 'Pete') }
  given!(:comedies) { Fabricate(:category, name: 'Comedies') }
  given!(:futurama) { Fabricate(:video, title: 'Futurama', category: comedies) }
  given!(:review1) { Fabricate(:review, video: futurama, author: pete) }

  background do
    login(jimmy)
    click_video_on_homepage(futurama)
    click_link('Pete')
  end

  scenario 'user sees and clicks Follow button on user he does not follow' do
    click_link('Follow')
    expect(page).to have_content('People I Follow')
    expect(page).to have_content('Pete')
  end
  
  scenario 'user does not see Follow button on user he is already following' do
    click_link('Follow')
    visit '/home'
    click_video_on_homepage(futurama)
    click_link('Pete')
    expect(page).not_to have_content('Follow')
  end

  scenario 'user unfollows a user from his list' do
    click_link('Follow')
    click_link("user_#{pete.id}_unfollow")
    expect(page).not_to have_content('Pete')
  end
end