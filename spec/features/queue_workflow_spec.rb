require 'spec_helper'

feature 'full queue workflow' do
  
  given(:user) { Fabricate(:user) }
  given(:video1) { Fabricate(:video) }

  scenario 'user signs in with correct credentials' do
    visit '/login'
    fill_in :email, with: user.email
    fill_in :password, with: user.password
    click_button 'Sign In'
    expect(page).to have_content('My Queue')
  end

  scenario 'user cannot sign in with incorrect credentials' do
    visit '/login'
    fill_in :email, with: user.email
    fill_in :password, with: 'wrong password'
    click_button 'Sign In'
    expect(page).to_not have_content('My Queue')
  end

  scenario 'user clicks a video on the homepage' do
    visit '/home'
    save_and_open_page
  end
end