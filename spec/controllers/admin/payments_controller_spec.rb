require 'spec_helper'

describe Admin::PaymentsController do
  it 'saves all payments to an instance variable' do
    set_up_admin_session
    payment1 = Fabricate(:payment)
    payment2 = Fabricate(:payment)
    payment3 = Fabricate(:payment)
    get :index
    expect(assigns(:payments)).to eq(Payment.all)
  end

  it_behaves_like 'require_admin' do
    let(:action) { get :index }
  end
end
