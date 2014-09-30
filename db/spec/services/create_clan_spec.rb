require 'rails_helper'
 
RSpec.describe CreateClan, :type => :service do

  let(:user) { double 'User' }
  let(:errors) { double 'Errors', :full_messages => [] }
  let(:listener) { double 'Listener' }

  let(:clan) { double 'Clan', :save => true, :errors => errors }

  before :each do
    stub_const 'Clan', double(:new => clan)
    @service = CreateClan.new
    @service.subscribe(listener)
  end

  describe '.call' do

    it 'succeeds on valid parameters' do
      expect(listener).to_not receive(:create_clan_failed)
      expect(clan).to receive(:save)
      expect(user).to receive(:clan=).with(clan)
      expect(user).to receive(:save)
      expect(listener).to receive(:create_clan_successful)

      @service.call user, 'name'
    end

    it 'fails when no user is specified' do
      expect(listener).to receive(:create_clan_failed)
      expect(clan).to_not receive(:save)
      expect(user).to_not receive(:clan=)
      expect(user).to_not receive(:save)
      expect(listener).to_not receive(:create_clan_successful)

      @service.call nil, 'name'
    end

    it 'fails when no name is specified' do
      expect(listener).to receive(:create_clan_failed)
      expect(clan).to_not receive(:save)
      expect(user).to_not receive(:clan=)
      expect(user).to_not receive(:save)
      expect(listener).to_not receive(:create_clan_successful)

      @service.call user, nil
    end

    it 'fails when saving the clan fails' do
      expect(listener).to receive(:create_clan_failed)
      expect(clan).to receive(:save).and_return(false)
      expect(user).to_not receive(:clan=)
      expect(user).to_not receive(:save)
      expect(listener).to_not receive(:create_clan_successful)

      @service.call user, 'name'
    end

  end
end