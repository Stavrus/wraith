class BadgeUserSerializer < ActiveModel::Serializer
  attributes :id, :badge_id, :match_id, :user_id, :name, :user, :created_at

  def name
    object.badge.name
  end

  def user
    object.user.name
  end

end