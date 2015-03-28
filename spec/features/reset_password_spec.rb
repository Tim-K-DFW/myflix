require 'spec_helper'

feature 'user resets password' do

  given!(:pete) { Fabricate(:user) }
  background { clear_emails }

  scenario 'user requests reset link' do
    visit '/login'
    expect(page).to have_content('Forgot password?')
    click_link('Forgot password?')
    expect(page).to have_content('We will send you an email')
   end

  scenario 'user fills request form with correct email' do
    visit '/login'
    click_link('Forgot password?')
    fill_in :email, with: pete.email
    click_button 'Send Email'
    expect(page).to have_content('We have sent an email')
    email = open_email(pete.email)
    expect(email.body).to include('You have just requested')
  end

  scenario 'user fills request form with incorrect email' do
    visit '/login'
    click_link('Forgot password?')
    fill_in :email, with: 'wrong_email@foo.bar'
    click_button 'Send Email'
    expect(page).to have_content('you forgot your email address')
    expect(page).to have_content('We will send you an email')
    expect(open_email(pete.email)).to be_nil
  end

  scenario 'user resets password by clicking the link' do
    visit '/login'
    click_link('Forgot password?')
    fill_in :email, with: pete.email
    click_button 'Send Email'
    email = open_email(pete.email)
    email.click_link('Reset your password')
    expect(page).to have_content('Reset Your Password')
    fill_in :password, with: '123'
    click_button('Reset Password')
    expect(page).to have_content('You have successfully reset')
    expect(page).to have_content('Sign in')
  end

  scenario 'user logs in with his new password' do
    reset_password_flow(pete)
    fill_in :email, with: pete.email
    fill_in :password, with: '123'
    click_button 'Sign In'
    expect(page).to have_content('Welcome,')
  end

  scenario 'user fails to log in with his old password' do
    reset_password_flow(pete)
    fill_in :email, with: pete.email
    fill_in :password, with: pete.password
    click_button 'Sign In'
    expect(page).to have_content('Invalid email or password.')
  end

  scenario 'user tries to use an expired link' do
    reset_password_flow(pete)
    email = open_email(pete.email)
    email.click_link('Reset your password')
    expect(page).to have_content('reset password link is expired.')
  end
end
