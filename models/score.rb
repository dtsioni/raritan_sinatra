class Score < ActiveRecord::Base
  belongs_to :professor

  validates_uniqueness_of :professor_id, :scope => :user_id

  validates_presence_of :easiness, :helpfulness, :clarity, :user_id
  validates_inclusion_of :easiness, :helpfulness, :clarity, :in => 1..5
  validates_inclusion_of :interesting, :work, :organization, :pacing, :in => 1..3

  METRICS = [:easiness, :clarity, :helpfulness, :interesting, :work, :organization, :pacing]

  def values_string
    ret = ""
    METRICS.each do |metric|
      ret += metric.to_s + " " + self.try(metric).to_s + " "
    end
    ret += "user: #{user_id} prof: #{professor_id}"
    return ret
  end
end
