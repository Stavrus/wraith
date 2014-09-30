require 'rails_helper'
 
RSpec.describe Token, :type => :model do

  subject { token }
  let(:token) { Token.new }

  it { expect(:uid).not_to be_empty }

  it { should validate_presence_of :rank }
  it { should validate_presence_of :match }
  it { should validate_presence_of :match_user }
  
end