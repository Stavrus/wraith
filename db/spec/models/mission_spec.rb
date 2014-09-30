require 'rails_helper'
 
RSpec.describe Mission, :type => :model do

  subject { mission }
  let(:mission) { Mission.new }

  it { should validate_presence_of :team_id }
  it { should validate_presence_of :match_id }
  it { should validate_presence_of :date_release }
  
end