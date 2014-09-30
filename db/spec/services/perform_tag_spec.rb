require 'rails_helper'
 
RSpec.describe PerformTag, :type => :service do

  let(:match) { double 'Match', :date_start => DateTime.now }
  let(:time_new) { 1.day.from_now }

  let(:human) { double 'Team', :name => 'Human' }
  let(:zombie) { double 'Team', :name => 'Zombie' }
  let(:source) { double 'MatchUser', :team => zombie, :bandanna => true, :waiver => true, :printed => true, :tags_count => 0 }
  let(:target) { double 'MatchUser', :team => human, :bandanna => true, :waiver => true, :printed => true, :token_rank => 1 }
  let(:errors) { double 'Errors', :full_messages => [] }
  let(:listener) { double 'Listener' }

  let(:tag) { double 'Tag', :errors => errors, :save => true }

  before :each do
    stub_const 'Tag', double(:new => tag)
    @service = PerformTag.new
    @service.subscribe(listener)
  end

  describe '.call' do

    it 'succeeds on valid parameters' do
      expect(listener).to_not receive(:perfom_tag_failed)

      expect(match).to receive(:date_start)

      expect(source).to receive(:bandanna)
      expect(source).to receive(:waiver)
      expect(source).to receive(:printed)
      expect(source).to receive(:team)

      expect(target).to receive(:bandanna)
      expect(target).to receive(:waiver)
      expect(target).to receive(:printed)
      expect(target).to receive(:team)

      expect(tag).to receive(:save)
      expect(target).to receive(:team=).with(zombie)
      expect(target).to receive(:token_rank=).with(2)
      expect(target).to receive(:save)

      expect(listener).to receive(:perform_tag_successful)

      @service.call match, source, target, nil, nil
    end

    it 'fails when no match is specified' do
      expect(listener).to receive(:perform_tag_failed)

      expect(tag).to_not receive(:save)
      expect(target).to_not receive(:save)

      expect(listener).to_not receive(:perform_tag_successful)

      @service.call nil, source, target, nil, nil
    end

    it 'fails when no source is specified' do
      expect(listener).to receive(:perform_tag_failed)

      expect(tag).to_not receive(:save)
      expect(target).to_not receive(:save)

      expect(listener).to_not receive(:perform_tag_successful)

      @service.call match, nil, target, nil, nil
    end

    it 'fails when no target is specified' do
      expect(listener).to receive(:perform_tag_failed)

      expect(tag).to_not receive(:save)
      expect(target).to_not receive(:save)

      expect(listener).to_not receive(:perform_tag_successful)

      @service.call match, source, nil, nil, nil
    end

    # Currently disabled as running it under rspec causes
    # different datetimes to return the same unix timestamp
    # it 'fails when the match has not yet started' do
    #   expect(listener).to receive(:perform_tag_failed)

    #   expect(match).to receive(:date_start).and_return(time_new)

    #   expect(tag).to_not receive(:save)
    #   expect(target).to_not receive(:save)

    #   expect(listener).to_not receive(:perform_tag_successful)

    #   @service.call match, source, target, nil, nil
    # end

    it 'fails when the tagging player is not a zombie' do
      expect(listener).to receive(:perform_tag_failed)

      expect(source).to receive(:team).and_return(human)

      expect(tag).to_not receive(:save)
      expect(target).to_not receive(:save)

      expect(listener).to_not receive(:perform_tag_successful)

      @service.call match, source, target, nil, nil
    end

    it 'fails when the victim player is not a human' do
      expect(listener).to receive(:perform_tag_failed)

      expect(target).to receive(:team).and_return(zombie)

      expect(tag).to_not receive(:save)
      expect(target).to_not receive(:save)

      expect(listener).to_not receive(:perform_tag_successful)

      @service.call match, source, target, nil, nil
    end

    it 'fails when the tagging player does not have a bandanna' do
      expect(listener).to receive(:perform_tag_failed)

      expect(source).to receive(:bandanna).and_return(false)

      expect(tag).to_not receive(:save)
      expect(target).to_not receive(:save)

      expect(listener).to_not receive(:perform_tag_successful)

      @service.call match, source, target, nil, nil
    end

    it 'fails when the tagging has not signed a waiver' do
      expect(listener).to receive(:perform_tag_failed)

      expect(source).to receive(:waiver).and_return(false)

      expect(tag).to_not receive(:save)
      expect(target).to_not receive(:save)

      expect(listener).to_not receive(:perform_tag_successful)

      @service.call match, source, target, nil, nil
    end

    it 'fails when the tagging player has not printed their id card' do
      expect(listener).to receive(:perform_tag_failed)

      expect(source).to receive(:printed).and_return(false)

      expect(tag).to_not receive(:save)
      expect(target).to_not receive(:save)

      expect(listener).to_not receive(:perform_tag_successful)

      @service.call match, source, target, nil, nil
    end

    it 'fails when the victim player does not have a bandanna' do
      expect(listener).to receive(:perform_tag_failed)

      expect(target).to receive(:bandanna).and_return(false)

      expect(tag).to_not receive(:save)
      expect(target).to_not receive(:save)

      expect(listener).to_not receive(:perform_tag_successful)

      @service.call match, source, target, nil, nil
    end

    it 'fails when the victim player has not signed a waiver' do
      expect(listener).to receive(:perform_tag_failed)

      expect(target).to receive(:waiver).and_return(false)

      expect(tag).to_not receive(:save)
      expect(target).to_not receive(:save)

      expect(listener).to_not receive(:perform_tag_successful)

      @service.call match, source, target, nil, nil
    end

    it 'fails when the victim player has not printed their id card' do
      expect(listener).to receive(:perform_tag_failed)

      expect(target).to receive(:printed).and_return(false)

      expect(tag).to_not receive(:save)
      expect(target).to_not receive(:save)

      expect(listener).to_not receive(:perform_tag_successful)

      @service.call match, source, target, nil, nil
    end

    it 'fails when the tag could not be saved' do
      expect(listener).to receive(:perform_tag_failed)

      expect(tag).to receive(:save).and_return(false)
      expect(target).to_not receive(:save)

      expect(listener).to_not receive(:perform_tag_successful)

      @service.call match, source, target, nil, nil
    end
  end

end