class Department < ActiveRecord::Base
  belongs_to :school
  has_many :professors

  validates_presence_of :name
  validates_uniqueness_of :name, :scope => :school_id
end
