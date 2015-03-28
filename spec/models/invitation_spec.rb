require 'spec_helper'

describe Invitation do
  it { is_expected.to validate_presence_of(:friend_name) }
  it { is_expected.to validate_presence_of(:friend_email) }
  it { is_expected.to validate_presence_of(:message) }

  it_behaves_like 'has_token' do
    let(:object) { Fabricate(:invitation) }
  end
end