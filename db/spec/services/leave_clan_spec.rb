require 'rails_helper'
 
RSpec.describe LeaveClan, :type => :service do

  let(:clan) { double 'Clan' }
  let(:user) { double 'User', :clan => clan }
  let(:user2) { double 'User', :clan => nil }
  let(:listener) { double 'Listener' }

  before :each do
    @service = LeaveClan.new
    @service.subscribe(listener)
  end

  describe '.call' do

    it 'succeeds on valid parameters' do
      expect(listener).to_not receive(:leave_clan_failed)
      expect(user).to receive(:clan=).with(nil)
      expect(user).to receive(:save)
      expect(listener).to receive(:leave_clan_successful)

      @service.call user
    end

    it 'fails when no user is specified' do
      expect(listener).to receive(:leave_clan_failed)
      expect(user).to_not receive(:clan=)
      expect(user).to_not receive(:save)
      expect(listener).to_not receive(:leave_clan_successful)

      @service.call nil
    end

    it 'fails when the user is not part of the given clan' do
      expect(listener).to receive(:leave_clan_failed)
      expect(user2).to_not receive(:clan=)
      expect(user2).to_not receive(:save)
      expect(listener).to_not receive(:leave_clan_successful)

      @service.call user2
    end

  end
end