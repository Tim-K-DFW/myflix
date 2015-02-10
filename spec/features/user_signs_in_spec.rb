require 'spec_helper'

feature 'user signs in' do
  
  given(:user) { Fabricate(:user) }

  scenario 'signing in with correct credentials' do
    visit '/login'
    fill_in :email, with: user.email
    fill_in :password, with: user.password
    click_button 'Sign In'
    
  end

  scenario 'trying to sign in with incorrect credentials' do
    visit '/login'
    fill_in :email, with: user.email
    fill_in :password, with: 'wrong password'
    click_button 'Sign In'
    expect(page).to_not have_content('My Queue')
  end
end