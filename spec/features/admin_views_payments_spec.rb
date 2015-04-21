require 'spec_helper'

feature 'admin views payments' do
  given(:pete) { Fabricate(:user, username: 'Pete', email: '1@1.com') }
  background do
    Fabricate(:payment, user: pete, amount: 999, reference_id: 'chrge1')
    Fabricate(:payment, user: pete, amount: 999, reference_id: 'chrge2')
    Fabricate(:payment, user: pete, amount: 999, reference_id: 'chrge3')
  end

  scenario 'admin goes to the payment view page' do
    login(Fabricate(:admin))
    visit '/admin/payments'
    expect(page).to have_content('Pete')
    expect(page).to have_content('1@1.com')
    expect(page).to have_content('$9.99')
    expect(page).to have_content('chrge2')
  end

  scenario 'user cannot view payments' do
    login(Fabricate(:user))
    visit 'admin/payments'
    expect(page).to have_content('need admin access')
    expect(page).not_to have_content('Pete')
    expect(page).not_to have_content('1@1.com')
    expect(page).not_to have_content('$9.99')
  end
end