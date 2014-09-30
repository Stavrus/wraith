require 'rails_helper'
 
RSpec.describe RejectClan, :type => :service do

  let(:clan) { double 'Clan' }
  let(:user) { double 'User', :clan => clan }
  let(:invite) { double 'ClanInvite', :clan => clan }
  let(:listener) { double 'Listener' }

  before :each do
    @service = RejectClan.new
    @service.subscribe(listener)
  end

  describe '.call' do
    
    it 'succeeds on valid parameters' do
      expect(listener).to_not receive(:reject_clan_failed)

      expect(invite).to receive(:pending=).with(false)
      expect(invite).to receive(:accepted=).with(false)
      expect(invite).to receive(:save)

      expect(listener).to receive(:reject_clan_successful)

      @service.call user, invite
    end

    it 'fails when no user is specified' do
      expect(listener).to receive(:reject_clan_failed)

      expect(invite).to_not receive(:pending=)
      expect(invite).to_not receive(:accepted=)
      expect(invite).to_not receive(:save)

      expect(listener).to_not receive(:reject_clan_successful)

      @service.call nil, invite
    end

    it 'fails when no invite is specified' do
      expect(listener).to receive(:reject_clan_failed)

      expect(invite).to_not receive(:pending=)
      expect(invite).to_not receive(:accepted=)
      expect(invite).to_not receive(:save)

      expect(listener).to_not receive(:reject_clan_successful)

      @service.call user, nil
    end

  end
end