require 'spec_helper'

feature 'a person registers with an invitation from a current user', { vcr: false, js: false } do
  let!(:alice){ Fabricate(:user, username: 'Alice') }
  before { login(alice) }
  after { clear_email }

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
    click_link('Welcome, Alice!')
    click_link('Sign Out')

    binding.pry
    open_email('fake@email.com')
    current_email.click_link('MyFlix Registration')
    expect(page).to have_content('Register')
    expect(find_field('user_email').value).to eq('fake@email.com')
    expect(find_field('user_username').value).to eq('Peter')
    fill_in 'Password', with: '123'
    fill_in 'Credit Card Number', with: '4242424242424242'
    fill_in 'Security Code', with: '123'
    select '2018', from: 'date_year'
    click_button('Sign up')
    expect(page).to have_content('Welcome, Peter!')

    click_link('People')
    expect(page).to have_content('Alice')

    click_link('Welcome, Peter!')
    click_link('Sign Out')
    login(alice)
    click_link('People')
    expect(page).to have_content('Peter')
  end
end
