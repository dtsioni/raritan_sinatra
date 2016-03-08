class School < ActiveRecord::Base
  has_many :departments

  validates :name, presence: true, uniqueness: true
end
