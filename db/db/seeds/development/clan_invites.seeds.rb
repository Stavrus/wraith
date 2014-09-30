after 'development:users', 'development:clans' do
  ClanInvite.create({:user_id => 2, :clan_id => 1, :sender_id => 1, :pending => false, :accepted => true})
  ClanInvite.create({:user_id => 3, :clan_id => 1, :sender_id => 1, :pending => false, :accepted => true})
  ClanInvite.create({:user_id => 4, :clan_id => 1, :sender_id => 1, :pending => false, :accepted => false})
  ClanInvite.create({:user_id => 5, :clan_id => 1, :sender_id => 1, :pending => true})
end