class ClanInvite < ActiveRecord::Base

  # Associations
  belongs_to :clan
  belongs_to :user
  belongs_to :sender, :class_name => 'User'

  # Scopes
  scope :pending,  ->(value) { where pending: value }
  scope :accepted, ->(value) { where accepted: value }

  # Validations
  validates :clan,   presence: true
  validates :user,   presence: true
  validates :sender, presence: true

  # Methods
  def self.filter(attributes)
    supported_filters = []
    attributes.slice(*supported_filters).inject(ClanInvite.all) do |scope, (key, value)|
      value.present? ? scope.send(key, value) : scope
    end
  end

end
