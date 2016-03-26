ENV['RACK_ENV'] = 'test'

require 'minitest/autorun'
require 'rack/test'
require 'database_cleaner'
require_relative 'app.rb'

include Rack::Test::Methods
set :environment, :test
def app
  Sinatra::Application
end
DatabaseCleaner.strategy = :truncation
before do
  DatabaseCleaner.clean
  @school_params = { name: "Rutgers University - New Brunswick" }
  @dept_cs_params = { name: "Computer Science" }
  @dept_math_params = { name: "Math" }
  @cs_prof1_params = { first_name: "Sesh", last_name: "Venugopal" }
  @cs_prof2_params = { first_name: "Andrew", last_name: "Tjang" }
  @math_prof1_params = { first_name: "Vladimir", last_name: "Shtelen" }

  school = School.create(@school_params)
  dept_cs = Department.create(@dept_cs_params)
  dept_math = Department.create(@dept_math_params)
  cs_prof1 = Professor.create(@cs_prof1_params)
  cs_prof2 = Professor.create(@cs_prof2_params)
  math_prof1 = Professor.create(@math_prof1_params)

  school.departments << dept_cs
  school.departments << dept_math
  dept_cs.professors << cs_prof1
  dept_cs.professors << cs_prof2
  dept_math.professors << math_prof1

  school.save
end

describe "Department" do
  before { get '/Rutgers%20University%20-%20New%20Brunswick/departments' }
  it "should return json" do
    last_response.headers['Content-Type'].must_equal 'application/json'
  end

  it "should return a list of departments" do
    departments_info = { departments: ["Computer Science", "Math"] }
    last_response.body.must_equal departments_info.to_json
  end
end

describe "Professors" do
  it "should return json" do
    get '/Rutgers%20University%20-%20New%20Brunswick/Computer%20Science/professors'
    last_response.headers['Content-Type'].must_equal 'application/json'
  end

  it "should return a list of professors from Computer Science" do
    get '/Rutgers%20University%20-%20New%20Brunswick/Computer%20Science/professors'
    professors_info = { professors: ["Sesh Venugopal", "Andrew Tjang"] }
    last_response.body.must_equal professors_info.to_json
  end

  it "should return a list of all professors" do
    get '/Rutgers%20University%20-%20New%20Brunswick/professors'
    professors_info = { professors: ["Sesh Venugopal", "Andrew Tjang", "Vladimir Shtelen"] }
    last_response.body.must_equal professors_info.to_json
  end
end

describe "Scores" do
  it "should post a score" do
    post_json("/Rutgers%20University%20-%20New%20Brunswick/Computer%20Science/Sesh%20Venugopal", {

      })
  end

  let(:resp) { json_parse(last_response.body) }
end

