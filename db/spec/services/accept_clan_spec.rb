require 'rails_helper'
 
RSpec.describe AcceptClan, :type => :service do

  let(:clan) { double 'Clan' }
  let(:user) { double 'User', :clan => clan }
  let(:invite) { double 'ClanInvite', :clan => clan }
  let(:listener) { double 'Listener' }

  before :each do
    @service = AcceptClan.new
    @service.subscribe(listener)
  end

  describe '.call' do
    
    it 'succeeds on valid parameters' do
      expect(listener).to_not receive(:accept_clan_failed)

      expect(user).to receive(:clan).and_return(double('ClanInvite'))
      expect(invite).to receive(:clan)

      expect(user).to receive(:clan=).with(clan)
      expect(user).to receive(:save)
      expect(invite).to receive(:pending=).with(false)
      expect(invite).to receive(:accepted=).with(true)
      expect(invite).to receive(:save)

      expect(listener).to receive(:accept_clan_successful)

      @service.call user, invite
    end

    it 'fails when no user is specified' do
      expect(listener).to receive(:accept_clan_failed)

      expect(user).to_not receive(:clan=)
      expect(user).to_not receive(:save)
      expect(invite).to_not receive(:pending=)
      expect(invite).to_not receive(:accepted=)
      expect(invite).to_not receive(:save)

      expect(listener).to_not receive(:accept_clan_successful)

      @service.call nil, invite
    end

    it 'fails when no invite is specified' do
      expect(listener).to receive(:accept_clan_failed)

      expect(user).to_not receive(:clan=)
      expect(user).to_not receive(:save)
      expect(invite).to_not receive(:pending=)
      expect(invite).to_not receive(:accepted=)
      expect(invite).to_not receive(:save)

      expect(listener).to_not receive(:accept_clan_successful)

      @service.call user, nil
    end

    it 'fails when the user was invited to the same clan' do
      expect(listener).to receive(:accept_clan_failed)

      expect(user).to receive(:clan)
      expect(invite).to receive(:clan)

      expect(user).to_not receive(:clan=)
      expect(user).to_not receive(:save)
      expect(invite).to_not receive(:pending=)
      expect(invite).to_not receive(:accepted=)
      expect(invite).to_not receive(:save)

      expect(listener).to_not receive(:accept_clan_successful)

      @service.call user, invite
    end

  end
end