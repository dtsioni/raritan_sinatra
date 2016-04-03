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
require './alias_helper'
# explicit routes should be higher
# return all professors from a department
get '/fpo/1/:school/:department/professors' do
  content_type :json
  professors = Array.new

  school = School.find_by(name: params[:school])
  halt 400, "School invalid" if school.nil?
  dept = school.departments.find_by(name: params[:department])
  halt 400, "Department invalid" if dept.nil?
  profs = dept.professors

  profs.each do |prof|
    professors.push "#{prof.full_name}"
  end
  ret = Hash.new
  ret[:professors] = professors
  return JSON.generate ret
end
# return all departments from a school
get '/fpo/1/:school/departments' do
  content_type :json
  departments = Array.new

  school = School.find_by(name: params[:school])
  halt 400, "School invalid" if school.nil?

  school.departments.each do |dept|
    departments.push(dept.name)
  end
  ret = Hash.new
  ret[:departments] = departments
  return JSON.generate ret
end

# create a professor
post '/fpo/1/:school/:department/:professor' do
  school = School.find_or_create_by(name: params[:school])
  halt 400, "School invalid" if school.nil?
  dept = school.departments.find_or_create_by(name: params[:department])
  halt 400, "Department invalid" if dept.nil?
  aliases = find_aliases(params[:professor], dept, school)
  prof = nil
  # set professor if we found an alias
  prof = aliases.first.professor if aliases.count == 1
  #find or create our new professor (including approximate names)
  if prof.nil?
    name = parse_name(params[:professor])
    professors = match_name(name, dept)
    #ambiguity
    halt 501, "Professor ambiguity" if professors.count > 1
    #matched
    if professors.count == 1
      prof = professors.first
      longer_name(prof, name[:first_name])
      Alias.create(name: params[:professor], professor_id: prof.id)
    end

    if professors.count == 0
      prof = Professor.new(first_name: name[:first_name], last_name: name[:last_name], department_id: dept.id)
      if prof.save
        Alias.create(name: params[:professor], professor_id: prof.id)
        halt 201, "New professor created"
      else
        halt 400, "Professor invalid"
      end
    end
  end
  status 200
  return nil
end
# post a new score for a professor
post '/fpo/1/:school/:department/:professor/scores' do
  #grab data from route
  data = JSON.parse(request.body.read)
  score = data["score"]
  user_id = data["user_id"]

  school = School.find_or_create_by(name: params[:school])
  halt 400, "School invalid" if school.nil?
  dept = school.departments.find_or_create_by(name: params[:department])
  halt 400, "Department invalid" if dept.nil?
  aliases = find_aliases(params[:professor], dept, school)
  prof = nil
  # set professor if we found an alias
  prof = aliases.first.professor if aliases.count == 1
  #find or create our new professor (including approximate names)
  if prof.nil?
    name = parse_name(params[:professor])
    professors = match_name(name, dept)
    #ambiguity
    halt 501, "Professor ambiguity" if professors.count > 1
    #matched
    if professors.count == 1
      prof = professors.first
      longer_name(prof, name[:first_name])
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



