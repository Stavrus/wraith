class TierSerializer < ActiveModel::Serializer
  attributes :id, :match_id, :name, :description, :date_release, :date_end, :total_votes, :tier_options_attributes

  # Active Model Serializers isn't accepting :root to rename tier_options
  def tier_options_attributes
    object.tier_options.map do |x| 
      {id: x.id, name: x.name, votes: x.votes_for.size, voted_for: current_user.voted_for?(x) }
    end
  end

end