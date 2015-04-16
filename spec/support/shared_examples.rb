shared_examples 'require_login' do
  it 'redirects to register page if user is not signed in' do
    clear_session
    action
    expect(response).to redirect_to register_path
  end
end

shared_examples 'require_admin' do
  before do
    set_up_session
    action
  end

  it 'generates flash error' do
    expect(flash[:danger]).to be_present
  end

  it 'redirects anyone who is not admin to home path' do
    expect(response).to redirect_to(home_path)
  end
end

shared_examples 'has_token' do
  it 'generates a token upon creation' do
    expect(object.token).to be_present
  end
end

shared_examples 'doesnt_create_new_user' do
  it 'does not create new User record' do
    signup_handle.signup('fake_sripe_token')
    expect(User.all.count).to eq(0)
  end

  it 'does not send welcome email' do
    signup_handle.signup('fake_sripe_token')
    expect(ActionMailer::Base.deliveries).to be_empty
  end

  it 'sets @status to :failed' do
    signup_handle.signup('fake_sripe_token')
    expect(signup_handle.instance_variable_get(:@status)).to eq(:failed)
  end
end