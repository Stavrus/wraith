class ClanUser < ActiveRecord::Base

  # Associations
  belongs_to :clan
  belongs_to :user

  # Validations
  validates :clan,      presence: true
  validates :user,      presence: true
  validates :date_join, presence: true

  # Methods
  def self.filter(attributes)
    supported_filters = []
    attributes.slice(*supported_filters).inject(ClanUser.all) do |scope, (key, value)|
      value.present? ? scope.send(key, value) : scope
    end
  end

end
