require 'spec_helper'

describe 'ChargeFailed', :vcr do
  after { ActionMailer::Base.deliveries.clear }

  let(:request_data){
    {
      "id" => "evt_15v6ZQBYANZ2AhsmLhKpdkmh",
      "created" => 1429881016,
      "livemode" => false,
      "type" => "charge.failed",
      "data" => {
        "object" => {
          "id" => "ch_15v6ZQBYANZ2AhsmnxsueRRy",
          "object" => "charge",
          "created" => 1429881016,
          "livemode" => false,
          "paid" => false,
          "status" => "failed",
          "amount" => 999,
          "currency" => "usd",
          "refunded" => false,
          "source" => {
            "id" => "card_15v6YhBYANZ2AhsmjuZAfTwg",
            "object" => "card",
            "last4" => "0341",
            "brand" => "Visa",
            "funding" => "credit",
            "exp_month" => 4,
            "exp_year" => 2018,
            "fingerprint" => "XDvOIJbkTDIoebS2",
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
            "metadata" => {},
            "customer" => "cus_661Ek9s9uRtiu7"
          },
          "captured" => false,
          "balance_transaction" => nil,
          "failure_message" => "Your card was declined.",
          "failure_code" => "card_declined",
          "amount_refunded" => 0,
          "customer" => "cus_661Ek9s9uRtiu7",
          "invoice" => nil,
          "description" => "will fail",
          "dispute" => nil,
          "metadata" => {},
          "statement_descriptor" => nil,
          "fraud_details" => {},
          "receipt_email" => nil,
          "receipt_number" => nil,
          "shipping" => nil,
          "application_fee" => nil,
          "refunds" => {
            "object" => "list",
            "total_count" => 0,
            "has_more" => false,
            "url" => "/v1/charges/ch_15v6ZQBYANZ2AhsmnxsueRRy/refunds",
            "data" => []
          }
        }
      },
      "object" => "event",
      "pending_webhooks" => 2,
      "request" => "iar_67LFXMD8SoS9Lm",
      "api_version" => "2015-03-24"
    }    
  }

  it 'locks account of associated user' do
    pete = Fabricate(:user, stripe_customer_id: 'cus_661Ek9s9uRtiu7')
    post '/stripe_events', request_data
    expect(pete.reload).to be_locked
  end

  it 'sends lock notification email' do
    pete = Fabricate(:user, stripe_customer_id: 'cus_661Ek9s9uRtiu7')
    post '/stripe_events', request_data
    expect(ActionMailer::Base.deliveries.last.subject).to match(/locked/)
  end
end
