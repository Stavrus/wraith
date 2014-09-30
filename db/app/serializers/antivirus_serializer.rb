class AntivirusSerializer < ActiveModel::Serializer
  attributes :id, :match_id, :uid, :description, :user

  def user
    object.match_user.user.name if object.match_user
  end

end