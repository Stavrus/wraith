class TierOption < ActiveRecord::Base
  acts_as_votable

  # Associations
  belongs_to :tier

  # Validations
  validates :tier, presence: true
  validates :name, presence: true,
                   uniqueness: {:scope => :tier_id}

  # Methods
  def self.filter(attributes)
    supported_filters = []
    attributes.slice(*supported_filters).inject(TierOption.all) do |scope, (key, value)|
      value.present? ? scope.send(key, value) : scope
    end
  end

end
