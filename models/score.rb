class Score < ActiveRecord::Base
  belongs_to :professor

  validates_uniqueness_of :professor_id, :scope => :user_id

  validates_presence_of :fairness, :helpfulness, :clarity, :user_id
  validates_inclusion_of :fairness, :helpfulness, :clarity, :in => 1..5
  validates_inclusion_of :preparation, :homework, :participation, :interesting, :attendance, :in => 1..3

  def values_string
    ret = ""
    Professor::METRICS.each do |metric|
      ret += metric.to_s + " " + self.try(metric).to_s + " "
    end
    ret += "user: #{user_id} prof: #{professor_id}"
    return ret
  end
end
