ENV['RACK_ENV'] = 'test'

require 'minitest/autorun'
require 'rack/test'
require 'database_cleaner'
require 'multi_json'
require 'mocha/setup'
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
  let(:vote){ { score: {
      fairness: 3,
      clarity: 5,
      helpfulness: 3,
      preparation: 1,
      homework: 3,
      participation: 1,
      interesting: 2,
      attendance: 2
    }, user_id: 1 }.to_json}

  let(:score_1){{ score: {
      fairness: 3,
      clarity: 5,
      helpfulness: 3,
      preparation: 1,
      homework: 3,
      participation: 1,
      interesting: 2,
      attendance: 2 }}.to_json}

  let(:low_vote){ { score: {
      fairness: 1,
      clarity: 1,
      helpfulness: 1,
      preparation: 1,
      homework: 1,
      participation: 1,
      interesting: 1,
      attendance: 1
    }, user_id: 2 }.to_json}

  let(:average_score){ { score: {
      fairness: 2,
      clarity: 3,
      helpfulness: 2,
      preparation: 1,
      homework: 2,
      participation: 1,
      interesting: 1.5,
      attendance: 1.5 }}.to_json}

  it "should return status OK and their current score" do
    post("/Rutgers%20University%20-%20New%20Brunswick/Computer%20Science/Sesh%20Venugopal", vote, { "CONTENT_TYPE" => "application/json" })
    last_response.status.must_equal 200
    last_response.body.must_equal score_1.to_json
  end

  it "should return their average score" do
    post("/Rutgers%20University%20-%20New%20Brunswick/Computer%20Science/Sesh%20Venugopal", low_vote, { "CONTENT_TYPE" => "application/json" })
    last_response.status.must_equal 200
    last_response.body.must_equal average_score.to_json
  end

  it "should create a new professor and return their score" do
    baz = Professor.count
    post("/Rutgers%20University%20-%20New%20Brunswick/Computer%20Science/Brian%20Russell", vote, { "CONTENT_TYPE" => "application/json" })
    Professor.count.must_equal baz + 1
    last_response.status.must_equal 200
    last_response.body.must_equal score_1.to_json
  end

  it "should create aliases for an existing professor, without making new professors" do
    baz = Professor.count
    qux = Alias.count
    #Brian K Russell
    #Brian K. Russell
    #Russell, Brian
    #Russell, B
    #Russell, B.
    #Russell
    post("/Rutgers%20University%20-%20New%20Brunswick/Computer%20Science/Brian%20K%20Russell", vote, { "CONTENT_TYPE" => "application/json" })
    post("/Rutgers%20University%20-%20New%20Brunswick/Computer%20Science/Brian%20K.%20Russell", vote, { "CONTENT_TYPE" => "application/json" })
    post("/Rutgers%20University%20-%20New%20Brunswick/Computer%20Science/Russell%2C%20Brian", vote, { "CONTENT_TYPE" => "application/json" })
    post("/Rutgers%20University%20-%20New%20Brunswick/Computer%20Science/Russell%2C%20B", vote, { "CONTENT_TYPE" => "application/json" })
    post("/Rutgers%20University%20-%20New%20Brunswick/Computer%20Science/Russell%2C%20B.", vote, { "CONTENT_TYPE" => "application/json" })
    post("/Rutgers%20University%20-%20New%20Brunswick/Computer%20Science/Russell", vote, { "CONTENT_TYPE" => "application/json" })
    Professor.count.must_equal baz
    Alias.count.must_equal qux + 6
    last_response.status.must_equal 200
    last_response.body.must_equal vote.to_json
  end
end

