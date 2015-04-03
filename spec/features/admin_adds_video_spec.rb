require 'spec_helper'

feature 'admin adds a video' do
  scenario 'admin goes to the add video page' do
    login(Fabricate(:admin))
    visit '/admin/videos/new'
    expect(page).to have_content('Large cover')
  end

  scenario 'admin fills upload form' do
    fake_category = Fabricate(:category)
    login(Fabricate(:admin))
    visit '/admin/videos/new'
    fill_in 'Title', with: 'Fake video title'
    select(fake_category.name, from: 'Category')
    fill_in 'Description', with: 'blah blah'
    attach_file 'Large cover image', 'spec/support/wallstreet_cover_large.jpg'
    attach_file 'Small cover image', 'spec/support/wallstreet_cover_small.jpg'
    fill_in 'Video URL', with: 'www.fake.url'
    click_button 'Add Video'
    expect(page).to have_content('successfully')
  end

  scenario 'regular user sees the new video' do
    fake_category = Fabricate(:category)
    login(Fabricate(:admin))
    visit '/admin/videos/new'
    fill_in 'Title', with: 'Fake video title'
    select(fake_category.name, from: 'Category')
    fill_in 'Description', with: 'blah blah'
    attach_file 'Large cover image', 'spec/support/wallstreet_cover_large.jpg'
    attach_file 'Small cover image', 'spec/support/wallstreet_cover_small.jpg'
    fill_in 'Video URL', with: 'www.fake.url'
    click_button 'Add Video'
    click_link 'Sign Out'

    login
    expect(page.find('img')[:src]).to eq("/tmp/fake_video_title_cover_small.jpg")
    click_link 'Videos'
    click_link("video_#{Video.first.id}_link")
    expect(page.find('img')[:src]).to eq("/tmp/fake_video_title_cover_large.jpg")
    expect(page).to have_content('Fake video title')
    expect(page).to have_content('blah blah')
    expect(page.find_link('Watch Now')[:href]).to match(/fake\.url/)
  end
end
