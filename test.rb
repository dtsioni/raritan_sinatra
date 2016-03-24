ENV['RACK_ENV'] = 'test'

require 'minitest/autorun'
require 'rack/test'
require_relative 'app.rb'

include Rack::Test::Methods

def app
  Sinatra::Application
end

before do
  @school_params = { name: "Rutgers University - New Brunswick" }
  @dept_cs_params = { name: "Computer Science" }
  @dept_math_params = { name: "Math" }

  school = School.create(@school_params)
  dept1 = Department.create(@dept_cs_params)
  dept2 = Department.create(@dept_math_params)
end

describe "Department" do
  it "should return json" do
    get '/Rutgers%20University%20-%20New%20Brunswick/departments'
    last_response.headers['Content-Type'].must_equal 'application/json'
  end

  it "should return a list of departments" do
    get 'Rutgers%20University%20-%20New%20Brunswick/departments'
    departments_info = { "Rutgers University - New Brunswick" => ["Computer Science", "Math"] }
    last_response.body.must_equal departments_info.to_json
  end
end
