require 'rails_helper'
 
RSpec.describe KickClan, :type => :service do

  let(:clan) { double 'Clan' }
  let(:user) { double 'User', :clan => clan }
  let(:user2) { double 'User', :clan => double('Clan') }
  let(:target) { double 'User', :clan => clan }
  let(:listener) { double 'Listener' }

  before :each do
    @service = KickClan.new
    @service.subscribe(listener)
  end

  describe '.call' do

    it 'succeeds on valid parameters' do
      expect(listener).to_not receive(:kick_clan_failed)

      expect(user).to receive(:clan)
      expect(target).to receive(:clan)

      expect(target).to receive(:clan=).with(nil)
      expect(target).to receive(:save)

      expect(listener).to receive(:kick_clan_successful)

      @service.call user, target
    end

    it 'fails when no sender is specified' do
      expect(listener).to receive(:kick_clan_failed)

      expect(target).to_not receive(:clan=).with(nil)
      expect(target).to_not receive(:save)

      expect(listener).to_not receive(:kick_clan_successful)

      @service.call nil, target
    end

    it 'fails when no target is specified' do
      expect(listener).to receive(:kick_clan_failed)

      expect(target).to_not receive(:clan=).with(nil)
      expect(target).to_not receive(:save)

      expect(listener).to_not receive(:kick_clan_successful)

      @service.call user, nil
    end

    it 'fails when user is not part of a clan' do
      expect(listener).to receive(:kick_clan_failed)

      expect(user).to receive(:clan).and_return(nil)

      expect(target).to_not receive(:clan=).with(nil)
      expect(target).to_not receive(:save)

      expect(listener).to_not receive(:kick_clan_successful)

      @service.call user, target
    end

    it 'fails when target is not part of a clan' do
      expect(listener).to receive(:kick_clan_failed)

      expect(target).to receive(:clan).and_return(nil)

      expect(target).to_not receive(:clan=).with(nil)
      expect(target).to_not receive(:save)

      expect(listener).to_not receive(:kick_clan_successful)

      @service.call user, target
    end

    it 'fails when the user and the target are the same' do
      expect(listener).to receive(:kick_clan_failed)

      expect(user).to_not receive(:clan=).with(nil)
      expect(user).to_not receive(:save)

      expect(listener).to_not receive(:kick_clan_successful)

      @service.call user, user
    end

    it 'fails when the user and the target are not part of the same clan' do
      expect(listener).to receive(:kick_clan_failed)

      expect(user2).to receive(:clan)
      expect(target).to receive(:clan)

      expect(target).to_not receive(:clan=).with(nil)
      expect(target).to_not receive(:save)

      expect(listener).to_not receive(:kick_clan_successful)

      @service.call user2, target
    end

  end
end