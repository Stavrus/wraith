class BadgeUser < ActiveRecord::Base

  # Associations
  belongs_to :user
  belongs_to :badge
  counter_culture :badge
  belongs_to :match

  # Validations
  validates :user,  presence: true,
                    uniqueness: {:scope => [:match_id, :badge]}
  validates :badge, presence: true
  validates :match, presence: true
 
  # Methods
  def self.filter(attributes)
    supported_filters = []
    attributes.slice(*supported_filters).inject(BadgeUser.all) do |scope, (key, value)|
      value.present? ? scope.send(key, value) : scope
    end
  end

end