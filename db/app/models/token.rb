class Token < ActiveRecord::Base

  # Callbacks
  before_validation :ensure_uid

  # Scopes
  scope :active_match, -> { where match: Match.active }

  # Associations
  belongs_to :match
  belongs_to :match_user

  # Validations
  validates :uid, presence: true
  validates :rank, presence: true,
                   uniqueness: {:scope => :match_user_id}
  validates :match, presence: true
  validates :match_user, presence: true

  # Methods
  def ensure_uid
    self.uid = generate_uid if uid.blank?
  end

  private

    def generate_uid
      loop do
        uid = SecureRandom.hex(4)
        break uid unless Token.active_match.where(:uid => uid).first
      end
    end

end
