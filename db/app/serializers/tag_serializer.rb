class TagSerializer < ActiveModel::Serializer
  attributes :id, :source_id, :target_id, :match_id, :created_at, :source, :target

  def source
    object.source.user.name
  end

  def target
    object.target.user.name
  end

end