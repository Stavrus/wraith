class Mission < ActiveRecord::Base

  # Scopes
  scope :match_id, ->(value) { where match_id: value }
  scope :active, -> { where match: Match.active }
  scope :released, lambda { where(["date_release <= ?", Time.now]) }

  # Associations
  belongs_to :team
  belongs_to :match

  # Validations
  validates :team_id,      presence: true
  validates :match_id,     presence: true
  validates :date_release, presence: true

  # Methods
  def self.filter(attributes)
    supported_filters = [:match_id]
    attributes.slice(*supported_filters).inject(Mission.all) do |scope, (key, value)|
      value.present? ? scope.send(key, value) : scope
    end
  end

  # Determine what missions are showable.
  # Regular users get shown only the missions for the given match based on their team.
  def self.showable(user, match_id)
    return Mission.all if user && user.moderator?

    if user && match_id
      team_id = MatchUser.joins(:user, :match)
                         .where(:user => 1, :match_id => match_id)
                         .pluck(:team_id)
                         .first
      
      return Mission.match_id(match_id).released.where(:team_id => team_id) if team_id
    end

    Mission.none
  end

end
