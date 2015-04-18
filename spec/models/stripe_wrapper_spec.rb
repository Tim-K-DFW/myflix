require 'spec_helper'

describe StripeWrapper, :vcr do
  let(:valid_token) do
   Stripe::Token.create(
     card: {
       number: '4242424242424242',
       exp_month: 5,
       exp_year: 2018,
       cvc: 123
       }
   ).id
  end

  let(:invalid_token) do
   Stripe::Token.create(
     card: {
       number: '4000000000000002',
       exp_month: 5,
       exp_year: 2018,
       cvc: 123
       }
   ).id
  end

  describe StripeWrapper::Charge do
    describe '.create' do
      context 'with valid card info' do
        it 'creates a successful charge' do
          charge = StripeWrapper::Charge.create(
            amount: 999,
            token: valid_token,
            email: 'test@email.com',
          )
          expect(charge).to be_successful
        end
      end

      context 'with invalid card info' do
        let(:charge) { StripeWrapper::Charge.create(
          amount: 999,
          token: invalid_token,
          email: 'test@email.com',
          )
        }
        
        it 'creates a failed charge' do
          expect(charge).not_to be_successful
        end

        it 'sets error message' do
          expect(charge.error_message).to be_present
        end
      end # with invalid card info
    end # .create
  end

  describe StripeWrapper::Customer do
    describe '.create' do
      let(:pete){ Fabricate(:user) }

      it 'creates a customer with valid card info' do
        customer = StripeWrapper::Customer.create(
          token: valid_token,
          user: pete,
        )
        expect(customer).to be_successful
      end

      it 'does not create a customer with invalid card info' do
        customer = StripeWrapper::Customer.create(
          token: invalid_token,
          user: pete,
        )
        expect(customer).not_to be_successful
      end

      it 'returns error message with invalid card info' do
        customer = StripeWrapper::Customer.create(
          token: invalid_token,
          user: pete,
        )
        expect(customer.error_message).to match(/card was declined/)
      end
    end # .create
  end # StripeWrapper::Customer
end
