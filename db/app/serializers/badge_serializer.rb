class BadgeSerializer < ActiveModel::Serializer
  attributes :id, :name, :description, :badge_users_count

end