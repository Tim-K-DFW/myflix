require 'spec_helper'

describe 'ChargeSucceeded', :vcr do
  let(:request_data){
    {
      "id" => "evt_15tndSBYANZ2AhsmEhcfQANF",
      "created" => 1429569902,
      "livemode" => false,
      "type" => "charge.succeeded",
      "data" => {
        "object" => {
          "id" => "ch_15tndSBYANZ2AhsmkV0eIIcd",
          "object" => "charge",
          "created" => 1429569902,
          "livemode" => false,
          "paid" => true,
          "status" => "succeeded",
          "amount" => 999,
          "currency" => "usd",
          "refunded" => false,
          "source" => {
            "id" => "card_15tndRBYANZ2Ahsm4HFW0FZu",
            "object" => "card",
            "last4" => "4242",
            "brand" => "Visa",
            "funding" => "credit",
            "exp_month" => 4,
            "exp_year" => 2016,
            "fingerprint" => "Z9AjS2ZYDjKqxwaU",
            "country" => "US",
            "name" => nil,
            "address_line1" => nil,
            "address_line2" => nil,
            "address_city" => nil,
            "address_state" => nil,
            "address_zip" => nil,
            "address_country" => nil,
            "cvc_check" => "pass",
            "address_line1_check" => nil,
            "address_zip_check" => nil,
            "dynamic_last4" => nil,
            "metadata" => {
            },
            "customer" => "cus_65zcQiDhrNMRhN"
          },
          "captured" => true,
          "balance_transaction" => "txn_15tndSBYANZ2Ahsm5eULLP4H",
          "failure_message" => nil,
          "failure_code" => nil,
          "amount_refunded" => 0,
          "customer" => "cus_65zcQiDhrNMRhN",
          "invoice" => "in_15tndSBYANZ2AhsmX5z21nnP",
          "description" => nil,
          "dispute" => nil,
          "metadata" => {
          },
          "statement_descriptor" => nil,
          "fraud_details" => {
          },
          "receipt_email" => nil,
          "receipt_number" => nil,
          "shipping" => nil,
          "application_fee" => nil,
          "refunds" => {
            "object" => "list",
            "total_count" => 0,
            "has_more" => false,
            "url" => "/v1/charges/ch_15tndSBYANZ2AhsmkV0eIIcd/refunds",
            "data" => [

            ]
          }
        }
      },
      "object" => "event",
      "pending_webhooks" => 1,
      "request" => "iar_65zcXfNAy17Cs1",
      "api_version" => "2015-03-24"
    }
  }

  it 'creates a new payment' do
    post '/stripe_events', request_data
    expect(Payment.all.count).to eq(1)
  end

  it 'creates a payment for associated user' do
    pete = Fabricate(:user, stripe_customer_id: 'cus_65zcQiDhrNMRhN')
    post '/stripe_events', request_data
    expect(Payment.last.user).to eq(pete)
  end

  it 'creates payment with correct amount' do
    pete = Fabricate(:user, stripe_customer_id: 'cus_65zcQiDhrNMRhN')
    post '/stripe_events', request_data
    expect(Payment.last.amount).to eq(999)
  end

  it 'creates payment with correct reference id' do
    pete = Fabricate(:user, stripe_customer_id: 'cus_65zcQiDhrNMRhN')
    post '/stripe_events', request_data
    expect(Payment.last.reference_id).to eq('ch_15tndSBYANZ2AhsmkV0eIIcd')
  end
end
