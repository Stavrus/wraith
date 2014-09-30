class Tag < ActiveRecord::Base

  # Scopes
  scope :match_id, ->(value) { where match_id: value }

  # Associations
  belongs_to :match
  belongs_to :source, :class_name => 'MatchUser', :foreign_key => :source_id
  counter_culture :source
  belongs_to :target, :class_name => 'MatchUser', :foreign_key => :target_id

  # Validations
  validates :match,  presence: true
  validates :source, presence: true
  validates :target, presence: true

  # Methods
  def self.filter(attributes)
    supported_filters = [:match_id]
    attributes.slice(*supported_filters).inject(Tag.all) do |scope, (key, value)|
      value.present? ? scope.send(key, value) : scope
    end
  end
  
end
