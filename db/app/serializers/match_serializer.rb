class MatchSerializer < ActiveModel::Serializer
  attributes :id, :title, :reginfo, :date_start, :date_end, :active, :humans, :zombies

  def humans
    object.match_users.where(:team_id => 1).count
  end

  def zombies
    object.match_users.where(:team_id => 2).count
  end

end