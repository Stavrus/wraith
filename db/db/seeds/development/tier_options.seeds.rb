after 'development:tiers' do
  TierOption.create(:tier_id => 1, :name => 'Option 1')
  TierOption.create(:tier_id => 1, :name => 'Option 2')
  TierOption.create(:tier_id => 1, :name => 'Option 3')
  TierOption.create(:tier_id => 2, :name => 'Option 1')
  TierOption.create(:tier_id => 2, :name => 'Option 2')
  TierOption.create(:tier_id => 2, :name => 'Option 3')
end