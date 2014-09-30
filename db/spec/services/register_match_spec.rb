require 'rails_helper'
 
RSpec.describe RegisterMatch, :type => :service do

  let(:match) { double 'Match' }
  let(:user) { double 'User' }
  let(:listener) { double 'Listener' }
  let(:errors) { double 'Errors', :full_messages => [] }

  let(:match_user) { double 'MatchUser', :errors => errors, :save => true }

  before :each do
    stub_const 'MatchUser', double(:new => match_user)
    stub_const 'Token', double()
    @service = RegisterMatch.new
    @service.subscribe(listener)
  end

  describe '.call' do

    it 'succeeds on valid parameters' do
      expect(listener).to_not receive(:register_match_failed)
      expect(MatchUser).to receive(:new).with(hash_including(:match => match, :user => user, :oz_interest => false))
      expect(match_user).to receive(:save)
      expect(Token).to receive(:create!).twice
      expect(listener).to receive(:register_match_successful)

      @service.call match, user, nil
    end

    it 'succeeds on valid parameters and oz_interest = true' do
      expect(listener).to_not receive(:register_match_failed)
      expect(MatchUser).to receive(:new).with(hash_including(:match => match, :user => user, :oz_interest => true))
      expect(match_user).to receive(:save)
      expect(Token).to receive(:create!).twice
      expect(listener).to receive(:register_match_successful)

      @service.call match, user, true
    end

    it 'fails when no match is specified' do
      expect(listener).to receive(:register_match_failed)
      expect(MatchUser).to_not receive(:new)
      expect(match_user).to_not receive(:save)
      expect(Token).to_not receive(:create!)
      expect(listener).to_not receive(:register_match_successful)

      @service.call nil, user, nil
    end

    it 'fails when no user is specified' do
      expect(listener).to receive(:register_match_failed)
      expect(MatchUser).to_not receive(:new)
      expect(match_user).to_not receive(:save)
      expect(Token).to_not receive(:create!)
      expect(listener).to_not receive(:register_match_successful)

      @service.call match, nil, nil
    end

    it 'fails when match_user does not save' do
      expect(listener).to receive(:register_match_failed)
      expect(MatchUser).to receive(:new)
      expect(match_user).to receive(:save).and_return(false)
      expect(Token).to_not receive(:create!)
      expect(listener).to_not receive(:register_match_successful)

      @service.call match, user, nil
    end

  end
end