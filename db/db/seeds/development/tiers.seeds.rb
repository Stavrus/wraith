after 'development:matches', :teams do
  Tier.create({:match_id => 1, :team_id => 1, :date_release => Time.now, :date_end => Time.now})
  Tier.create({:match_id => 1, :team_id => 2, :date_release => Time.now, :date_end => Time.now})
  Tier.create({:match_id => 1, :team_id => 1, :date_release => Time.now, :date_end => Time.now})
  Tier.create({:match_id => 1, :team_id => 2, :date_release => Time.now, :date_end => Time.now})
end