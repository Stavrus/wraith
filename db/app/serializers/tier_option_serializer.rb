class TierOptionSerializer < ActiveModel::Serializer
  attributes :id, :votes, :name, :description

  def votes
    object.votes_for.size
  end

end