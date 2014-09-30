class Team < ActiveRecord::Base

  # Validations
  validates :name, presence: true,
                   uniqueness: true
                   
end
