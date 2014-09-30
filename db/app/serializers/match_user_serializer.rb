class MatchUserSerializer < ActiveModel::Serializer
  attributes :id, :user_id, :team_id, :name, :team, :clan, :clan_id, :tags_count,
            :uid, :waiver, :bandanna, :printed, :token_rank, :oz_interest
  has_many :tokens

  def name
    object.user.name
  end

  def team
    object.team.name
  end

  def clan
    object.user.clan.name if object.user.clan
  end

  def include_clan?
    !object.user.clan.nil?
  end

  def clan_id
    object.user.clan_id if object.user.clan
  end

  def include_clan_id?
    !object.user.clan_id.nil?
  end

  def include_uid?
    !scope.nil? && (scope.moderator? || object.user == scope)
  end

  def include_waiver?
    !scope.nil? && scope.moderator?
  end

  def include_bandanna?
    !scope.nil? && scope.moderator?
  end

  def include_printed?
    !scope.nil? && scope.moderator?
  end

  def include_token_rank?
    !scope.nil? && scope.moderator?
  end

  def include_oz_interest?
    !scope.nil? && scope.moderator?
  end

  def include_tokens?
    !scope.nil? && (scope.moderator? || object.user == scope)
  end

end