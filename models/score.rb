class Score < ActiveRecord::Base
  belongs_to :professor

  validates_uniqueness_of :professor_id, :scope => :user_id
end
