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
  user_id = data["user_id"]

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
  #check the alias table
  aliases = Alias.where(name: params[:professor])
  #filter for professors that are in the right department and school
  aliases.select{ |pseudo| pseudo.professor.department == dept }
  aliases.select{ |pseudo| pseudo.professor.department.school == school }

  prof = nil
  if aliases.count == 1
    #we found the professor
    prof = aliases.first.professor
  end

  if prof.nil?
    name = parse_name(params[:professor])
    professors = match_name(name, dept)

    #ambiguity
    if professors.count > 1
      status 501
      return nil
    end
    #matched
    if professors.count == 1
      prof = professors.first
      if prof.first_name.length < name[:first_name].length
        prof.first_name = name[:first_name]
        prof.save
      end
      Alias.create(name: params[:professor], professor_id: prof.id)
    end

    if professors.count == 0
      prof = Professor.new(first_name: name[:first_name], last_name: name[:last_name], department_id: dept.id)
      if prof.save
        Alias.create(name: params[:professor], professor_id: prof.id)
      else
        status 400
        return nil
      end
    end
  end


  if prof.present?
    previous_vote = Score.find_by(professor_id: prof.id, user_id: user_id)
    #has this user voted on this professor before?
    if previous_vote
      if previous_vote.update(score)
        status 200
        return prof.score
      else
        status 400
        return nil
      end
    end

    vote = Score.new(score.merge({professor_id: prof.id, user_id: user_id}))
    if vote.save
      status 201
      return prof.score
    else
      status 400
      return nil
    end
  else
    status 400
    return nil
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



