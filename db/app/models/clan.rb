class Clan < ActiveRecord::Base

  # Carrierwave
  mount_uploader :avatar, AvatarUploader
  mount_uploader :avatar_pending, AvatarUploader

  # Associations
  has_many :users

  # Validations
  validates :name,   presence: true, uniqueness: true

  # Methods
  def self.filter(attributes)
    supported_filters = []
    attributes.slice(*supported_filters).inject(Clan.all) do |scope, (key, value)|
      value.present? ? scope.send(key, value) : scope
    end
  end

end
