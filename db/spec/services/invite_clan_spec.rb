require 'rails_helper'
 
RSpec.describe InviteClan, :type => :service do

  let(:clan) { double 'Clan' }
  let(:user) { double 'User', :clan => clan }
  let(:target) { double 'User' }
  let(:listener) { double 'Listener' }

  before :each do
    stub_const 'ClanInvite', double(:create_with => double(:find_or_create_by => true))
    @service = InviteClan.new
    @service.subscribe(listener)
  end

  describe '.call' do

    it 'succeeds on valid parameters' do
      expect(listener).to_not receive(:invite_clan_failed)
      expect(listener).to receive(:invite_clan_successful)

      @service.call user, target
    end

    it 'fails when no sender is specified' do
      expect(listener).to receive(:invite_clan_failed)
      expect(listener).to_not receive(:invite_clan_successful)

      @service.call nil, target
    end

    it 'fails when no target is specified' do
      expect(listener).to receive(:invite_clan_failed)
      expect(listener).to_not receive(:invite_clan_successful)

      @service.call user, nil
    end

    it 'fails when saving the sender and the target are the same' do
      expect(listener).to receive(:invite_clan_failed)
      expect(listener).to_not receive(:invite_clan_successful)

      @service.call user, user
    end

  end
end