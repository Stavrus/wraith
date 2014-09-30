require 'rails_helper'
 
RSpec.describe Match, :type => :model do

  subject { match }
  let(:match) { Match.new }

  it { should validate_presence_of :date_start    }
  it { should validate_presence_of :date_end      }

end