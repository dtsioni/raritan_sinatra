require 'sinatra'
require 'sinatra/activerecord'
# load in models
require './models/school'
require './models/department'
require './models/professor'
require './models/score'
require './models/alias'
# database config
require './config/environments'
require './name_helper'
# our routes
# post a new score for this professor
post '/:school/:department/:professor' do
  #grab data from route
  data = JSON.parse(request.body.read)
  score = data["score"]

  school = School.find_or_create_by(name: params[:school])
  if school.nil?
    status 400
    return nil
  end
  dept = school.departments.find_or_create_by(name: params[:department])
  if dept.nil?
    status 400
    return nil
  end
  #hash of name
  name = parse_name(params[:professor])

  prof = dept.professors.find_by(name)

  if prof.present?
    vote = Score.new(score.merge({professor_id: prof.id}))
    if vote.save
      status 200
      return prof.score
    else
      status 400
      return nil
    end
  end
end
# return all professors from a department
get '/:school/:department/professors' do
  content_type :json
  professors = Array.new
  profs_rows = School.find_by(name: params[:school]).departments.find_by(name: params[:department]).professors
  profs_rows.each do |prof|
    professors.push "#{prof.first_name} #{prof.last_name}"
  end
  ret = Hash.new
  ret[:professors] = professors
  return JSON.generate ret
end
# return all departments from a school
get '/:school/departments' do
  content_type :json
  departments = Array.new()
  School.find_by(name: params[:school]).departments.each do |dept|
    departments.push(dept.name)
  end
  ret = Hash.new
  ret[:departments] = departments
  return JSON.generate ret
end
# return all professors from a school
get '/:school/professors' do
  content_type :json
  professors = Array.new
  profs_rows = School.find_by(name: params[:school]).professors
  profs_rows.each do |prof|
    professors.push "#{prof.first_name} #{prof.last_name}"
  end
  ret = Hash.new
  ret[:professors] = professors
  return JSON.generate ret
end



