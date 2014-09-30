class User < ActiveRecord::Base
  acts_as_voter

  # Callbacks
  before_validation :ensure_role_is_set

  # Devise
  devise :trackable

  # Carrierwave
  mount_uploader :avatar, AvatarUploader
  mount_uploader :avatar_pending, AvatarUploader

  # Scopes
  scope :clan, ->(value)  { where clan_id: value }

  # Associations
  has_many :matches
  has_many :match_users
  belongs_to :role
  belongs_to :clan
  counter_culture :clan

  # Validations
  validates :role,  presence: true
  validates :email,    presence: true, uniqueness: true
  validates :uid,      presence: true, uniqueness: true
 
  # Methods
  def self.filter(attributes)
    supported_filters = [:clan]
    attributes.slice(*supported_filters).inject(User.all) do |scope, (key, value)|
      value.present? ? scope.send(key, value) : scope
    end
  end

  def ensure_role_is_set
    if self.role.nil?
      self.role = Role.find_by_name 'Normal'
    end
  end

  def has_role?(role)
    self.role.name.downcase.eql? role.to_s
  end

  def moderator?
    (self.admin?) || (self.has_role? :moderator)
  end

  def admin?
    self.has_role? :admin
  end

  def ensure_authentication_token
    if authentication_token.blank?
      self.authentication_token = generate_authentication_token
      self.auth_expires = 1.hour.from_now
    end
  end

  def refresh_authentication_token
    if self.auth_expires < Time.now
      self.authentication_token = generate_authentication_token
    end

    self.auth_expires = 1.hour.from_now
  end

  def team
    self.team
  end

  def team=(team)
    self.team= team
  end

  private
  
    def generate_authentication_token
      loop do
        token = SecureRandom.urlsafe_base64(64)
        break token unless User.where(authentication_token: token).first
      end
    end

end
