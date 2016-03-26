require 'sinatra'
require 'sinatra/activerecord'
# load in models
require './models/school'
require './models/department'
require './models/professor'
require './models/score'
# database config
require './config/environments'
# our routes
# post a new score for this professor
post '/:school/:department/:professor' do
  status 200
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



