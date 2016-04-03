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
require './helpers/name_helper'
require './helpers/alias_helper'
# explicit routes should be higher
# return all professors from a department
get '/fpo/1/:school/:department/professors' do
  content_type :json

  school = School.find_by(name: params[:school])
  halt 400, "School invalid" if school.nil?
  dept = school.departments.find_by(name: params[:department])
  halt 400, "Department invalid" if dept.nil?

  ret = Hash.new
  ret[:professors] = dept.professors.map{ |baz| baz.full_name }
  return JSON.generate ret
end
# return all departments from a school
get '/fpo/1/:school/departments' do
  content_type :json

  school = School.find_by(name: params[:school])
  halt 400, "School invalid" if school.nil?

  ret = Hash.new
  ret[:departments] = school.departments.map{ |baz| baz.name }
  return JSON.generate ret
end
# create a professor or alias
post '/fpo/1/:school/:department/:professor' do
  school = School.find_or_create_by(name: params[:school])
  halt 400, "School invalid" if school.nil?
  dept = school.departments.find_or_create_by(name: params[:department])
  halt 400, "Department invalid" if dept.nil?
  #if this is already an alias, we know the professor exists
  halt 200, "Professor exists" if find_aliases(params[:professor], dept, school).count == 1
  #find or create our new professor (including approximate names)
  name = parse_name(params[:professor])
  professors = match_name(name, dept)

  halt 501, "Professor ambiguity" if professors.count > 1

  if professors.count == 1
    prof = professors.first
    pick_longer_name(prof, name[:first_name])
    Alias.create(name: params[:professor], professor_id: prof.id)
    halt 200, "Professor exists, alias created"
  end
  #if professors.count = 0
  prof = Professor.new(first_name: name[:first_name], last_name: name[:last_name], department_id: dept.id)
  if prof.save
    Alias.create(name: params[:professor], professor_id: prof.id)
    halt 201, "Professor created"
  else
    halt 400, "Professor invalid"
  end
end
# post a new score for a professor
post '/fpo/1/:school/:department/:professor/scores' do
  #grab data from route
  data = JSON.parse(request.body.read)
  halt 400, "Score invalid" if data.nil?
  score = data["score"]
  user_id = data["user_id"]

  school = School.find_or_create_by(name: params[:school])
  halt 400, "School invalid" if school.nil?
  dept = school.departments.find_or_create_by(name: params[:department])
  halt 400, "Department invalid" if dept.nil?

  aliases = find_aliases(params[:professor], dept, school)
  prof = nil

  prof = aliases.first.professor if aliases.count == 1
  #find or create our new professor (including approximate names)
  if prof.nil?
    name = parse_name(params[:professor])
    professors = match_name(name, dept)

    halt 501, "Professor ambiguity" if professors.count > 1
    #matched
    if professors.count == 1
      prof = professors.first
      pick_longer_name(prof, name[:first_name])
      Alias.create(name: params[:professor], professor_id: prof.id)
    end

    if professors.count == 0
      prof = Professor.new(first_name: name[:first_name], last_name: name[:last_name], department_id: dept.id)
      if prof.save
        Alias.create(name: params[:professor], professor_id: prof.id)
      else
        halt 400, "Professor invalid"
      end
    end
  end
  #if we found them, then post their score
  if prof.present?
    previous_vote = Score.find_by(professor_id: prof.id, user_id: user_id)
    #has this user voted on this professor before?
    if previous_vote
      if previous_vote.update(score)
        status 200
        return prof.score
      else
        halt 400, "Score invalid"
      end
    end
    vote = Score.new(score.merge({professor_id: prof.id, user_id: user_id}))
    if vote.save
      status 201
      return prof.score
    else
      halt 400, "Score invalid"
      return nil
    end
  else
    halt 400
  end
end



