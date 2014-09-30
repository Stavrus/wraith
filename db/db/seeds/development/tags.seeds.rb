after 'development:users', 'development:matches' do
  Tag.create(:source_id => 1, :target_id => 2, :match_id => 1)
  Tag.create(:source_id => 1, :target_id => 3, :match_id => 1)
  Tag.create(:source_id => 1, :target_id => 4, :match_id => 1)
  Tag.create(:source_id => 1, :target_id => 5, :match_id => 1)

  Tag.create(:source_id => 46, :target_id => 47, :match_id => 2)
  Tag.create(:source_id => 47, :target_id => 48, :match_id => 2)
  Tag.create(:source_id => 48, :target_id => 49, :match_id => 2)
  Tag.create(:source_id => 49, :target_id => 50, :match_id => 2)
end