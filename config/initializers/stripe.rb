Stripe.api_key = ENV['stripe_api_key']

StripeEvent.configure do |events|
  events.subscribe 'charge.succeeded' do |event|
    user = User.find_by_stripe_customer_id(event.data.object.customer)
    Payment.create(
      user: user,
      amount: event.data.object.amount,
      reference_id: event.data.object.id
    )
  end
end
