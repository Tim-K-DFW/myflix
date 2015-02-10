require 'spec_helper'

feature 'full queue workflow' do
  
  given!(:user) { Fabricate(:user) }
  given!(:cat1) { Fabricate(:category) }
  given!(:video1) { Fabricate(:video, category: cat1) }

  scenario 'user clicks a video on the homepage and ends up on the correct video page' do
    sign_in
    add_video_to_queue(video1)
    expect(page).to have_content(video1.title)
  end

  scenario 'user adds video to queue' do
    sign_in
    add_video_to_queue(video1)
    click_link('+ My Queue')
    expect(page).to have_content(video1.title)
  end

  scenario 'user clicks video link on the queue page' do
    sign_in
    add_video_to_queue(video1)
    click_link('+ My Queue')
    click_link(video1.title)
    save_and_open_page
    expect(page).to have_content(video1.description)
    expect(page).to have_no_content('+ My Queue')
  end

  def sign_in
    visit '/login'
    fill_in :email, with: user.email
    fill_in :password, with: user.password
    click_button 'Sign In'
  end

  def add_video_to_queue(video)
    click_link("video_#{video.id}_link")
  end
end