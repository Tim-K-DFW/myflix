require 'spec_helper'

feature 'user signs in' do
  scenario 'signing in with correct credentials' do
    user = Fabricate(:user)
    visit '/login'
    fill_in :email, with: user.email
    fill_in :password, with: user.password
    click_button 'Sign In'
    expect(page).to have_content('My Queue')    
  end

  scenario 'trying to sign in with incorrect credentials' do
    user = Fabricate(:user)
    visit '/login'
    fill_in :email, with: user.email
    fill_in :password, with: 'wrong password'
    click_button 'Sign In'
    expect(page).to_not have_content('My Queue')
  end

  scenario 'trying to sign in with locked account' do
    user = Fabricate(:user, locked: true)
    visit '/login'
    fill_in :email, with: user.email
    fill_in :password, with: user.password
    click_button 'Sign In'
    expect(page).to_not have_content('My Queue')
    expect(page).to have_content('locked')
  end
end