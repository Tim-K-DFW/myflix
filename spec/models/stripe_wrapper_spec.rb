require 'spec_helper'

describe StripeWrapper::Charge do
  before { StripeWrapper.set_api_key }
  let(:token) do
    Stripe::Token.create(
      card: {
        number: card_number,
        exp_month: 5,
        exp_year: 2018,
        cvc: 123
      }
    ).id
  end

  context 'with valid card info' do
    let(:card_number) { '4242424242424242' }

    it 'creates a successful charge' do
      charge = StripeWrapper::Charge.create(
        amount: 999,
        token: token,
        description: 'test'
      )
      expect(charge).to be_successful
    end
  end

  context 'with invalid card info' do
    let(:card_number) { '4000000000000002' }
    let(:charge) { StripeWrapper::Charge.create(
      amount: 999,
      token: token,
      description: 'test'
      )
    }
    
    it 'creates a failed charge' do
      expect(charge).not_to be_successful
    end

    it 'sets error message' do
      expect(charge.error_message).to be_present
    end
  end
end
