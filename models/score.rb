class Score < ActiveRecord::Base
  belongs_to :professor
  has_and_belongs_to_many :tags

  validates_uniqueness_of :professor_id, :scope => :user_id
end
