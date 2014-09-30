class ClanSerializer < ActiveModel::Serializer
  attributes :id, :name, :users_count
  has_many :users

end