after 'development:users', 'development:clans' do
  ClanUser.create({:user_id => 1, :clan_id => 1, :date_join => Time.now})
  ClanUser.create({:user_id => 2, :clan_id => 1, :date_join => Time.now})
  ClanUser.create({:user_id => 3, :clan_id => 1, :date_join => Time.now, :date_left => Time.now})
  ClanUser.create({:user_id => 3, :clan_id => 2, :date_join => Time.now})
end