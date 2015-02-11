require 'spec_helper'

feature 'full queue workflow' do
  
  given!(:user) { Fabricate(:user) }
  given!(:cat1) { Fabricate(:category) }
  given!(:video1) { Fabricate(:video, category: cat1) }

  scenario 'user clicks a video on the homepage' do
    sign_in
    click_link("video_#{video1.id}_link")
    expect(page).to have_content(video1.title)
  end

  scenario 'user adds video to queue and goes to queue page' do
    sign_in
    add_video_to_queue(video1)
    click_link('My Queue')
    expect(page).to have_content(video1.title)
  end

  scenario 'user clicks video link on the queue page' do
    sign_in
    add_video_to_queue(video1)
    click_link('My Queue')
    click_link(video1.title)
    expect(page).to have_content(video1.description)
    expect(page).to_not have_content('+ My Queue')
  end

  scenario 'user rearranges videos in queue' do
    video2 = Fabricate(:video, category: cat1)
    video3 = Fabricate(:video, category: cat1)
    
    sign_in
    [video1, video2, video3].each { |video|  add_video_to_queue(video) }
    click_link('My Queue')
    fill_in position(video1), with: '5'
    fill_in position(video2), with: '3'
    fill_in position(video3), with: '4'
    click_button 'Update Instant Queue'
    expect(find_field(position(video1)).value).to eq('3')
    expect(find_field(position(video2)).value).to eq('1')
    expect(find_field(position(video3)).value).to eq('2')
  end

  def sign_in
    visit '/login'
    fill_in :email, with: user.email
    fill_in :password, with: user.password
    click_button 'Sign In'
  end

  def add_video_to_queue(video) # from the homepage - clicks video, adds it to queue and goes back to home page
    click_link("video_#{video.id}_link")
    click_link('+ My Queue')
    click_link('Videos')
  end

  def position(video) # HTML id for a queue item, given a video and user; used both to fill and evaluate positions
    "queue_item_#{video.lines.where(user: user).first.id}_position"
  end
end