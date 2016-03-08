class Professor < ActiveRecord::Base
  belongs_to :department
  has_many :scores
  has_many :aliases
  has_and_belongs_to_many :tags

  validates_presence_of :first_name, :last_name
  validates_uniqueness_of :first_name, :scope => :last_name
end
