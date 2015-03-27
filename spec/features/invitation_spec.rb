require 'spec_helper'

feature 'a person registers with an invitation from a current user' do
  before { login }

  scenario 'current user sends an invitation' do
    click_link('Invite')
    fill_in 'Friend\'s Name', with: 'Peter'
    fill_in 'Friend\'s Email Address', with: 'fake@email.com'
    click_button('Send Invitation')
    expect(page).to have_content('Invitation to Peter has been sent successfully')
  end

  scenario 'person clicks invitation link' do
    click_link('Invite')
    fill_in 'Friend\'s Name', with: 'Peter'
    fill_in 'Friend\'s Email Address', with: 'fake@email.com'
    click_button('Send Invitation')
    click_link('Sign Out')

    open_email('fake@email.com')
    current_email.click_link('MyFlix Registration')
    expect(page).to have_content('Register')
    binding.pry
    # expect(find('Email address')).to have_content('Register')
    

  end

end