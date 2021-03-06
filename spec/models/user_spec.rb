require 'spec_helper'

describe 'User' do

  describe '#follows?' do
    it 'returns true if user follows another user' do
      alice = Fabricate(:user)
      pete = Fabricate(:user)
      Following.create(leader: alice, follower: pete)
      expect(pete.follows?(alice)).to be_truthy
    end

    it 'returns false if user does not follow another user' do
      alice = Fabricate(:user)
      pete = Fabricate(:user)
      expect(pete.follows?(alice)).to be_falsey
    end
  end

  describe '#can_follow?' do
    it 'returns true if user is not already following another user and is not that user' do
      alice = Fabricate(:user)
      pete = Fabricate(:user)
      expect(pete.can_follow?(alice)).to be_truthy
    end

    it 'returns false if user is already following another user' do
      alice = Fabricate(:user)
      pete = Fabricate(:user)
      Following.create(leader: alice, follower: pete)
      expect(pete.can_follow?(alice)).to be_falsey
    end

    it 'returns false if user the argument, that is another user' do
      pete = Fabricate(:user)
      expect(pete.can_follow?(pete)).to be_falsey
    end
  end

  describe '#generate_token' do
    let(:pete) { Fabricate(:user) }

    it 'updates token attribute' do
      pete.generate_token
      expect(pete.token).not_to be_nil
    end
  end

  describe '#follow' do
    
    it 'makes user follow another user' do
      alice = Fabricate(:user)
      pete = Fabricate(:user)
      alice.follow(pete)
      expect(alice.follows?(pete)).to be_truthy
    end

    it 'does not allow a user to follow himself' do
      alice = Fabricate(:user)
      alice.follow(alice)
      expect(alice.follows?(alice)).to be_falsey
    end
  end

end