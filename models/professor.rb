class Professor < ActiveRecord::Base
  belongs_to :department
  has_many :scores
  has_many :aliases

  validates_presence_of :last_name, :department
  validates_uniqueness_of :first_name, :scope => :last_name

  #returns json object of their average score
  def score
    ary = Professor.scores.group_by { |h| h.keys.first }.map do |k,v|
      { k => v.map { |h| h[k][0].to_i }.inject(:+) / v.size }
    end
  end
end
