class School < ActiveRecord::Base
  has_many :departments
  has_many :professors, through: :departments

  validates :name, presence: true, uniqueness: true
end
