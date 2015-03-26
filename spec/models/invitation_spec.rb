require 'spec_helper'

describe Invitation do
  it { is_expected.to validate_presence_of(:friend_name) }
  it { is_expected.to validate_length_of(:friend_name).is_at_least(3).is_at_most(50) }
  # it { is_expected.to validate_presence_of(:friend_email) }
  # it { is_expected.to validate_presence_of(:message) }
  # it { is_expected.to validate_length_of(:message).is_at_least(7).is_at_most(255) }
  # it { is_expected.to validate_uniqueness_of(:friend_email) }

end