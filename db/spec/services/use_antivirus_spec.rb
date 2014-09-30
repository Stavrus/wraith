require 'rails_helper'
 
RSpec.describe UseAntivirus, :type => :service do

  let(:match) { double 'Match' }
  let(:human) { double 'Team', :name => 'Human' }
  let(:zombie) { double 'Team', :name => 'Zombie' }

  let(:match_user) { double 'MatchUser', :match => match, :team => zombie, :save => true }
  let(:av) { double 'Antivirus', :match => match, :match_user => nil, :save => true }
  let(:listener) { double 'Listener' }

  before :each do
    stub_const 'Team', double(:find_by_name => zombie)
    @service = UseAntivirus.new
    @service.subscribe(listener)
  end

  describe '.call' do

    it 'succeeds on valid parameters' do
      expect(listener).to_not receive(:use_antivirus_failed)
      expect(match_user).to receive(:team)
      expect(av).to receive(:match_user)
      expect(match_user).to receive(:match)
      expect(av).to receive(:match)
      expect(match_user).to receive(:team=).with(zombie)
      expect(av).to receive(:match_user=).with(match_user)
      expect(listener).to receive(:use_antivirus_successful)

      @service.call match_user, av
    end

    it 'fails when no match_user is specified' do
      expect(listener).to receive(:use_antivirus_failed)
      expect(match_user).to_not receive(:team)
      expect(av).to_not receive(:match_user)
      expect(match_user).to_not receive(:match)
      expect(av).to_not receive(:match)
      expect(match_user).to_not receive(:team=).with(zombie)
      expect(av).to_not receive(:match_user=).with(match_user)
      expect(listener).to_not receive(:use_antivirus_successful)

      @service.call nil, av
    end

    it 'fails when no av is specified' do
      expect(listener).to receive(:use_antivirus_failed)
      expect(match_user).to_not receive(:team)
      expect(av).to_not receive(:match_user)
      expect(match_user).to_not receive(:match)
      expect(av).to_not receive(:match)
      expect(match_user).to_not receive(:team=).with(zombie)
      expect(av).to_not receive(:match_user=).with(match_user)
      expect(listener).to_not receive(:use_antivirus_successful)

      @service.call match_user, nil
    end

    it 'fails when match_user is not a zombie' do
      expect(listener).to receive(:use_antivirus_failed)
      expect(match_user).to receive(:team).and_return(human)
      expect(av).to_not receive(:match_user)
      expect(match_user).to_not receive(:match)
      expect(av).to_not receive(:match)
      expect(match_user).to_not receive(:team=).with(zombie)
      expect(av).to_not receive(:match_user=).with(match_user)
      expect(listener).to_not receive(:use_antivirus_successful)

      @service.call match_user, av
    end

    it 'fails when the av has already been used' do
      expect(listener).to receive(:use_antivirus_failed)
      expect(match_user).to receive(:team)
      expect(av).to receive(:match_user).and_return(match_user)
      expect(match_user).to_not receive(:match)
      expect(av).to_not receive(:match)
      expect(match_user).to_not receive(:team=).with(zombie)
      expect(av).to_not receive(:match_user=).with(match_user)
      expect(listener).to_not receive(:use_antivirus_successful)

      @service.call match_user, av
    end

    it 'fails when the av and the match_user are not part of the same match' do
      expect(listener).to receive(:use_antivirus_failed)
      expect(match_user).to receive(:team)
      expect(av).to receive(:match_user)
      expect(match_user).to receive(:match).and_return double('Match')
      expect(av).to receive(:match)
      expect(match_user).to_not receive(:team=).with(zombie)
      expect(av).to_not receive(:match_user=).with(match_user)
      expect(listener).to_not receive(:use_antivirus_successful)

      @service.call match_user, av
    end

  end
end