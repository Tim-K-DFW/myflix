require 'spec_helper'

describe Invitation do
  it { is_expected.to validate_presence_of(:friend_name) }
  it { is_expected.to validate_presence_of(:friend_email) }
  it { is_expected.to validate_presence_of(:message) }

  describe '#generate_token' do
    let(:invitation) { Fabricate(:invitation) }

    it 'creates token attribute' do
      invitation.generate_token
      expect(invitation.token).not_to be_nil
    end
  end
end