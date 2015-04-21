require 'spec_helper'

describe PaymentsController do
  it 'saves all payments to an instance variable' do
    payment1 = Fabricate(:payment)
    payment2 = Fabricate(:payment)
    payment3 = Fabricate(:payment)
    get :index
    expect(assigns(:payments)).to eq(Payment.all)
  end
end
