require 'rails_helper'
 
RSpec.describe Role, :type => :model do

  subject { role }
  let(:role) { Role.new }
  
  it { should validate_presence_of   :name }
  it { should validate_uniqueness_of :name  }
  
end