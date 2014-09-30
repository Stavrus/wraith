class Match < ActiveRecord::Base

  # Associations
  has_many :match_users

  # Validations
  validates :date_start,    presence: true
  validates :date_end,      presence: true

  # Methods
  def self.active
    where(:active => true).first
  end

end
