require 'rails_helper'
 
RSpec.describe Team, :type => :model do

  subject { team }
  let(:team) { Team.new }
  
  it { should validate_presence_of   :name }
  it { should validate_uniqueness_of :name  }
  
end