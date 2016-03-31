class Professor < ActiveRecord::Base
  belongs_to :department
  has_many :scores
  has_many :aliases

  validates_presence_of :last_name, :department
  validates_uniqueness_of :first_name, :scope => :last_name

  METRICS = [:fairness, :clarity, :helpfulness, :preparation, :homework, :participation, :interesting, :attendance]

  #returns json object of average score
  def score
    puts "!!!!"
    return nil if scores.count == 0
    average = Hash.new(0)
    puts Score.all.count
    scores.each_with_index do |score, num|
      puts score.values_string
      METRICS.each do |metric|
        average[metric] = (average[metric] * num + score.try(metric))/(num + 1)
      end
    end
    ret = {score: average}
    return JSON.generate ret
  end
end
