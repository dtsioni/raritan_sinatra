class Score < ActiveRecord::Base
  belongs_to :professor

  validates_uniqueness_of :professor_id, :scope => :user_id

  validates_presence_of :fairness, :helpfulness, :clarity
  validates_inclusion_of :fairness, :helpfulness, :clarity, :in 1..5
  validates_inclusion_of :preparation, :homework, :participation, :interesting, :attendance, :in 1..3
end
