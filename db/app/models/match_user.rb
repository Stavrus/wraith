class MatchUser < ActiveRecord::Base

  # Callbacks
  before_validation :ensure_uid

  # Scopes
  scope :active_match, -> { where match: Match.active }
  scope :match, ->(value) { where match_id: value }
  scope :team, ->(value) { where team_id: value }
  scope :user, ->(value)  { where user_id: value }

  # Associations
  belongs_to :match
  belongs_to :team
  belongs_to :user
  has_many :tags, :foreign_key => :source_id
  has_many :tokens

  # Validations
  validates :uid,   presence: true,
                    uniqueness: {:scope => :match_id}
  validates :match, presence: true
  validates :team,  presence: true
  validates :user,  presence: true,
                    uniqueness: {:scope => :match_id}

  # Methods
  def self.filter(attributes)
    supported_filters = [:match, :team, :user]
    attributes.slice(*supported_filters).inject(MatchUser.all) do |scope, (key, value)|
      value.present? ? scope.send(key, value) : scope
    end
  end

  def self.printed

  end

  def self.bandanna

  end

  def self.waiver

  end

  def ensure_uid
    self.uid = generate_uid if uid.blank?
  end

  private

    def generate_uid
      loop do
        uid = SecureRandom.hex(4)
        break uid unless MatchUser.active_match.where(:uid => uid).pluck(:id).first
      end
    end

end
