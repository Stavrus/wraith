class MissionSerializer < ActiveModel::Serializer
  attributes :id, :title, :description, :date_release, :team_id

end