class Tier < ActiveRecord::Base

  # Scopes
  scope :active_match, -> { where match: Match.active }
  scope :match, ->(value) { where match_id: value }
  scope :released, lambda { where(["date_release <= ?", Time.now]) }

  # Associations
  belongs_to :match
  belongs_to :team
  has_many :tier_options
  accepts_nested_attributes_for :tier_options

  # Validations
  validates :match,        presence: true
  validates :team,         presence: true
  validates :date_release, presence: true
  validates :date_end,     presence: true

  # Methods
  def self.filter(attributes)
    supported_filters = []
    attributes.slice(*supported_filters).inject(Tier.all) do |scope, (key, value)|
      value.present? ? scope.send(key, value) : scope
    end
  end

  # Determine what tiers are showable.
  # Regular users get shown only the tiers for the given match based on their team.
  def self.showable(user, match_id)
    return Tier.all if user && user.moderator?

    if user && match_id
      team_id = MatchUser.joins(:user, :match)
                         .where(:user => user, :match_id => match_id)
                         .pluck(:team_id)
                         .first
      return Tier.match(match_id).released.where(:team_id => team_id) if team_id
    end

    Tier.none
  end

  def total_votes
    sum = 0
    tier_options.each do |obj|
      sum += obj.votes_for.size
    end
    sum
  end

end
