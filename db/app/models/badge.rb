class Badge < ActiveRecord::Base

  # Associations
  has_many :badge_users
  counter_culture :badge_users

  # Validations
  validates :name, presence: true
 
  # Methods
  def self.filter(attributes)
    supported_filters = []
    attributes.slice(*supported_filters).inject(Badge.all) do |scope, (key, value)|
      value.present? ? scope.send(key, value) : scope
    end
  end

end