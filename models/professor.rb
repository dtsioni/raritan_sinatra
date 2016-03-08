class Professor < ActiveRecord::Base
  belongs_to :department
  has_many :scores
  has_many :aliases
  has_many :tags, through: :scores

  validates_presence_of :first_name, :last_name, :department
  validates_uniqueness_of :first_name, :scope => :last_name
end
