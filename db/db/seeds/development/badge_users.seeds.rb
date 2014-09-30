after :badges do
  BadgeUser.create({:badge_id => 1, :user_id => 1, :match_id => 1})
  BadgeUser.create({:badge_id => 2, :user_id => 1, :match_id => 1})
  BadgeUser.create({:badge_id => 3, :user_id => 1, :match_id => 1})
  BadgeUser.create({:badge_id => 4, :user_id => 2, :match_id => 1})
  BadgeUser.create({:badge_id => 5, :user_id => 2, :match_id => 1})
  BadgeUser.create({:badge_id => 6, :user_id => 3, :match_id => 1})
  BadgeUser.create({:badge_id => 7, :user_id => 4, :match_id => 1})
end