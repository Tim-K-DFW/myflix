require 'spec_helper'

feature 'new user registration', { vcr: true, js: true } do
  scenario 'with invalid personal info and valid card' do
    fill_form(email: nil, card_number: '4242424242424242')
    expect(page).to have_content('There was a problem with your input')
  end

  scenario 'with invalid personal info and invalid card' do
    fill_form(email: nil, card_number: '4')
    expect(page).to have_content('card number looks invalid')
  end

  scenario 'with invalid personal info and declined card' do
    fill_form(email: nil, card_number: '4000000000000002')
    expect(page).to have_content('There was a problem with your input')
  end

  scenario 'with valid personal info and valid card' do
    fill_form(email: 'fake@email.com', card_number: '4242424242424242')
    expect(page).to have_content('Welcome to MyFlix')
  end

  scenario 'with valid personal info and invalid card' do
    fill_form(email: 'fake@email.com', card_number: '4')
    expect(page).to have_content('card number looks invalid')
  end


  scenario 'with valid personal info and declined card' do
    fill_form(email: 'fake@email.com', card_number: '4000000000000002')
    expect(page).to have_content('card was declined')
  end
end

def fill_form(args)
  visit '/'
  click_link 'Sign Up Now!'
  fill_in 'Email Address', with: args[:email]
  fill_in 'Password', with: '123'
  fill_in 'Full Name', with: 'Pete'
  fill_in 'Credit Card Number', with: args[:card_number]
  fill_in 'Security Code', with: '123'
  select '2018', from: 'date_year'
  click_button('Sign up')
end