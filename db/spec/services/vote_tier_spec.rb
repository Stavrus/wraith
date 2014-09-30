require 'rails_helper'
 
RSpec.describe VoteTier, :type => :service do

  let(:match) { double 'Match' }
  let(:human) { double 'Team', :name => 'Human' }
  let(:zombie) { double 'Team', :name => 'Zombie' }

  let(:user) { double 'User' }
  let(:match_user) { double 'MatchUser', :user => user, :match => match, :team => zombie}
  let(:tier) { double 'Tier', :match => match, :team => zombie }
  let(:option) { double 'Option', :tier => tier }
  let(:option2) { double 'Option', :tier => tier }

  let(:listener) { double 'Listener' }

  before :each do
    @service = VoteTier.new
    @service.subscribe(listener)
  end

  describe '.call' do

    it 'succeeds on valid parameters' do
      expect(listener).to_not receive(:vote_tier_failed)

      expect(match_user).to receive(:team)
      expect(tier).to receive(:team)

      expect(match_user).to receive(:match)
      expect(tier).to receive(:match)

      expect(option).to receive(:tier)

      expect(tier).to receive(:tier_options).and_return([option, option2])
      expect(option).to receive(:unliked_by).with(user)
      expect(option2).to receive(:unliked_by).with(user)
      expect(option).to receive(:liked_by).with(user)
      expect(option2).to_not receive(:liked_by).with(user)

      expect(listener).to receive(:vote_tier_successful)

      @service.call match_user, tier, option
    end

    it 'fails when no match_user is specified' do
      expect(listener).to receive(:vote_tier_failed)

      expect(option).to_not receive(:unliked_by).with(user)
      expect(option2).to_not receive(:unliked_by).with(user)
      expect(option).to_not receive(:liked_by).with(user)
      expect(option2).to_not receive(:liked_by).with(user)

      expect(listener).to_not receive(:vote_tier_successful)

      @service.call nil, tier, option
    end

    it 'fails when no tier is specified' do
      expect(listener).to receive(:vote_tier_failed)

      expect(option).to_not receive(:unliked_by).with(user)
      expect(option2).to_not receive(:unliked_by).with(user)
      expect(option).to_not receive(:liked_by).with(user)
      expect(option2).to_not receive(:liked_by).with(user)

      expect(listener).to_not receive(:vote_tier_successful)

      @service.call match_user, nil, option
    end

    it 'fails when no option is specified' do
      expect(listener).to receive(:vote_tier_failed)

      expect(option).to_not receive(:unliked_by).with(user)
      expect(option2).to_not receive(:unliked_by).with(user)
      expect(option).to_not receive(:liked_by).with(user)
      expect(option2).to_not receive(:liked_by).with(user)

      expect(listener).to_not receive(:vote_tier_successful)

      @service.call match_user, tier, nil
    end

    it 'fails when the match_user and the tier are not on the same team' do
      expect(listener).to receive(:vote_tier_failed)

      expect(match_user).to receive(:team)
      expect(tier).to receive(:team).and_return(human)

      expect(option).to_not receive(:unliked_by).with(user)
      expect(option2).to_not receive(:unliked_by).with(user)
      expect(option).to_not receive(:liked_by).with(user)
      expect(option2).to_not receive(:liked_by).with(user)

      expect(listener).to_not receive(:vote_tier_successful)

      @service.call match_user, tier, option
    end

    it 'fails when the match_user and the tier are not on the same team' do
      expect(listener).to receive(:vote_tier_failed)

      expect(match_user).to receive(:team)
      expect(tier).to receive(:team).and_return(human)

      expect(option).to_not receive(:unliked_by).with(user)
      expect(option2).to_not receive(:unliked_by).with(user)
      expect(option).to_not receive(:liked_by).with(user)
      expect(option2).to_not receive(:liked_by).with(user)

      expect(listener).to_not receive(:vote_tier_successful)

      @service.call match_user, tier, option
    end

    it 'fails when the match_user and the tier are not on the same match' do
      expect(listener).to receive(:vote_tier_failed)

      expect(match_user).to receive(:match)
      expect(tier).to receive(:match).and_return(double('Match'))

      expect(option).to_not receive(:unliked_by).with(user)
      expect(option2).to_not receive(:unliked_by).with(user)
      expect(option).to_not receive(:liked_by).with(user)
      expect(option2).to_not receive(:liked_by).with(user)

      expect(listener).to_not receive(:vote_tier_successful)

      @service.call match_user, tier, option
    end

    it 'fails when the option does not belong to the given tier' do
      expect(listener).to receive(:vote_tier_failed)

      expect(option).to receive(:tier).and_return(double('Tier'))

      expect(option).to_not receive(:unliked_by).with(user)
      expect(option2).to_not receive(:unliked_by).with(user)
      expect(option).to_not receive(:liked_by).with(user)
      expect(option2).to_not receive(:liked_by).with(user)

      expect(listener).to_not receive(:vote_tier_successful)

      @service.call match_user, tier, option
    end

  end
end