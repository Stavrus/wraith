require 'rails_helper'

RSpec.describe User, :type => :model do

  subject { user }
  let(:user) { User.new }

  it { should validate_presence_of :uid }
  it { should validate_presence_of :role }
  it { should validate_presence_of :email }
  
end
