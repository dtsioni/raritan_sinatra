class Alias < ActiveRecord::Base
  belongs_to :professor

  validates_presence_of :name, :professor_id
  validates_uniqueness_of :name, :scope => :professor_id
end
