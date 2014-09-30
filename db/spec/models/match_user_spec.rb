require 'rails_helper'
 
RSpec.describe MatchUser, :type => :model do

  subject { match_user }
  let(:match_user) { MatchUser.new }

  it { expect(:uid).not_to be_empty }

  it { should validate_presence_of :match }
  it { should validate_presence_of :team  }
  it { should validate_presence_of :user  }

end