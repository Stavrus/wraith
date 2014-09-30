require 'rails_helper'
 
RSpec.describe CreateAntiviri, :type => :service do

  let(:match) { double 'Match', :date_start => DateTime.now }
  let(:av) { double 'Antivirus' }
  let(:listener) { double 'Listener' }

  before :each do
    stub_const 'Antivirus', double(:new => av, :create => av)
    @service = CreateAntiviri.new
    @service.subscribe(listener)
  end

  describe '.call' do
    
    it 'succeeds on valid parameters' do
      expect(listener).to_not receive(:create_antiviri_failed)
      expect(listener).to receive(:create_antiviri_successful)

      @service.call 5, match
    end

    it 'fails when no quantity is specified' do
      expect(listener).to receive(:create_antiviri_failed)
      expect(listener).to_not receive(:create_antiviri_successful)

      @service.call nil, match
    end

    it 'fails when no match is specified' do
      expect(listener).to receive(:create_antiviri_failed)
      expect(listener).to_not receive(:create_antiviri_successful)

      @service.call 5, nil
    end

    it 'fails when a non-integer quantity is specified' do
      expect(listener).to receive(:create_antiviri_failed)
      expect(listener).to_not receive(:create_antiviri_successful)

      @service.call '5', match
    end

  end
end