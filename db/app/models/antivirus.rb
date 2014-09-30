class Antivirus < ActiveRecord::Base

  # Callbacks
  before_validation :ensure_uid

  # Scopes
  scope :active_match, -> { where match: Match.active }
  scope :match, ->(value) { where match_id: value }

  # Associations
  belongs_to :match
  belongs_to :match_user

  # Validations
  validates :uid,   presence: true,
                    uniqueness: {:scope => :match_id}
  validates :match, presence: true

  # Methods
  def self.filter(attributes)
    supported_filters = []
    attributes.slice(*supported_filters).inject(Antivirus.all) do |scope, (key, value)|
      value.present? ? scope.send(key, value) : scope
    end
  end

  def ensure_uid
    self.uid = generate_uid if uid.blank?
  end

  private

    def generate_uid
      loop do
        uid = SecureRandom.hex(4)
        break uid unless Antivirus.active_match.where(:uid => uid).pluck(:id).first
      end
    end

end
