require 'rails_helper'
 
RSpec.describe Tag, :type => :model do

  subject { tag }
  let(:tag) { Tag.new }

  it { should validate_presence_of :match }
  it { should validate_presence_of :source }
  it { should validate_presence_of :target }
  
end