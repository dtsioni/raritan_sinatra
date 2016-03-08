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
end
# return all professors from a department
get '/:school/:department/professors' do
  content_type :json
  school = params[:school]
  { school: school }.to_json
end
# return all departments from a school
get '/:school/departments' do
end
# return all professors from a school
get '/:school/professors' do
end



