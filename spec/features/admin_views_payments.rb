require 'spec_helper'

feature 'admin views payments' do
  scenario 'admin goes to the payment view page' do
    login(Fabricate(:admin))
    visit '/admin/payments'
    expect(page).to have_content('Pete')
    expect(page).to have_content('1@1.com')
    expect(page).to have_content('chrge2')
  end
end