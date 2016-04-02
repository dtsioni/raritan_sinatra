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

DatabaseCleaner.clean

describe "Creating initial data" do

  let(:vote){ { score: { fairness: 3, clarity: 5, helpfulness: 3, preparation: 1, homework: 3, participation: 1, interesting: 2, attendance: 2  }, user_id: 1 }.to_json}

  it "initial data should create a new professor, department, and school" do
    DatabaseCleaner.clean
    foo = Professor.count
    baz = Department.count
    qux = School.count
    post("/fpo/1/Rutgers%20University%20-%20New%20Brunswick/Computer%20Science/Sesh%20Venugopal/scores", vote, { "CONTENT_TYPE" => "application/json" })
    School.count.must_equal foo + 1
    Department.count.must_equal baz + 1
    Professor.count.must_equal qux + 1
  end
end

describe "Scores" do
  let(:vote){ { score: { fairness: 3, clarity: 5, helpfulness: 3, preparation: 1, homework: 3, participation: 1, interesting: 2, attendance: 2  }, user_id: 1 }.to_json}
  let(:score_1){ { score: { fairness: 3.0, clarity: 5.0, helpfulness: 3.0, preparation: 1.0, homework: 3.0, participation: 1.0, interesting: 2.0, attendance: 2.0 }}.to_json}
  let(:low_vote){ { score: { fairness: 1,  clarity: 1, helpfulness: 1, preparation: 1, homework: 1, participation: 1, interesting: 1, attendance: 1 }, user_id: 2 }.to_json}
  let(:low_vote_1){ { score: { fairness: 1,  clarity: 1, helpfulness: 1, preparation: 1, homework: 1, participation: 1, interesting: 1, attendance: 1 }, user_id: 1 }.to_json}
  let(:average_score){ { score: { fairness: 2.0, clarity: 3.0, helpfulness: 2.0, preparation: 1.0, homework: 2.0, participation: 1.0, interesting: 1.5, attendance: 1.5 }}.to_json}

  it "should return status OK and their current score" do
    DatabaseCleaner.clean
    post("/fpo/1/Rutgers%20University%20-%20New%20Brunswick/Computer%20Science/Sesh%20Venugopal/scores", vote, { "CONTENT_TYPE" => "application/json" })
    last_response.status.must_equal 201
    last_response.body.must_equal score_1
  end

  it "should return their average score" do
    DatabaseCleaner.clean
    post("/fpo/1/Rutgers%20University%20-%20New%20Brunswick/Computer%20Science/Sesh%20Venugopal/scores", vote, { "CONTENT_TYPE" => "application/json" })
    post("/fpo/1/Rutgers%20University%20-%20New%20Brunswick/Computer%20Science/Sesh%20Venugopal/scores", low_vote, { "CONTENT_TYPE" => "application/json" })
    last_response.status.must_equal 201
    last_response.body.must_equal average_score
  end

  it "should create a new professor and return their score" do
    DatabaseCleaner.clean
    baz = Professor.count
    post("/fpo/1/Rutgers%20University%20-%20New%20Brunswick/Computer%20Science/Brian%20Russell/scores", vote, { "CONTENT_TYPE" => "application/json" })
    Professor.count.must_equal baz + 1
    last_response.status.must_equal 201
    last_response.body.must_equal score_1
  end

  it "should create aliases for an existing professor, without making new professors" do
    vote_2 = { score: { fairness: 3, clarity: 5, helpfulness: 3, preparation: 1, homework: 3, participation: 1, interesting: 2, attendance: 2  }, user_id: 2 }.to_json
    vote_3 = { score: { fairness: 3, clarity: 5, helpfulness: 3, preparation: 1, homework: 3, participation: 1, interesting: 2, attendance: 2  }, user_id: 3 }.to_json
    vote_4 = { score: { fairness: 3, clarity: 5, helpfulness: 3, preparation: 1, homework: 3, participation: 1, interesting: 2, attendance: 2  }, user_id: 4 }.to_json
    vote_5 = { score: { fairness: 3, clarity: 5, helpfulness: 3, preparation: 1, homework: 3, participation: 1, interesting: 2, attendance: 2  }, user_id: 5 }.to_json
    vote_6 = { score: { fairness: 3, clarity: 5, helpfulness: 3, preparation: 1, homework: 3, participation: 1, interesting: 2, attendance: 2  }, user_id: 6 }.to_json
    vote_7 = { score: { fairness: 3, clarity: 5, helpfulness: 3, preparation: 1, homework: 3, participation: 1, interesting: 2, attendance: 2  }, user_id: 7 }.to_json
    DatabaseCleaner.clean
    qux = Alias.count
    #Brian K Russell
    #Brian K. Russell
    #Russell, Brian
    #Russell, B
    #Russell, B.
    #Russell
    post("/fpo/1/Rutgers%20University%20-%20New%20Brunswick/Computer%20Science/Russell/scores", vote_7, { "CONTENT_TYPE" => "application/json" })
    post("/fpo/1/Rutgers%20University%20-%20New%20Brunswick/Computer%20Science/Brian%20K%20Russell/scores", vote_2, { "CONTENT_TYPE" => "application/json" })
    post("/fpo/1/Rutgers%20University%20-%20New%20Brunswick/Computer%20Science/Brian%20K.%20Russell/scores", vote_3, { "CONTENT_TYPE" => "application/json" })
    post("/fpo/1/Rutgers%20University%20-%20New%20Brunswick/Computer%20Science/Russell%2C%20Brian/scores", vote_4, { "CONTENT_TYPE" => "application/json" })
    post("/fpo/1/Rutgers%20University%20-%20New%20Brunswick/Computer%20Science/Russell%2C%20B/scores", vote_5, { "CONTENT_TYPE" => "application/json" })
    post("/fpo/1/Rutgers%20University%20-%20New%20Brunswick/Computer%20Science/Russell%2C%20B./scores", vote_6, { "CONTENT_TYPE" => "application/json" })
    Professor.count.must_equal 1
    Alias.count.must_equal qux + 6
    last_response.status.must_equal 201
    last_response.body.must_equal score_1
  end

  it "should update your vote" do
    DatabaseCleaner.clean
    post("/fpo/1/Rutgers%20University%20-%20New%20Brunswick/Computer%20Science/Brian%20K%20Russell/scores", vote, { "CONTENT_TYPE" => "application/json" })
    post("/fpo/1/Rutgers%20University%20-%20New%20Brunswick/Computer%20Science/Brian%20K%20Russell/scores", low_vote_1, { "CONTENT_TYPE" => "application/json" })

    last_response.status.must_equal 200
  end
end

describe "Department" do
  let(:departments){ { departments: ["Computer Science", "Math"]}.to_json}

  it "should return a list of departments" do
    DatabaseCleaner.clean
    vote = { score: { fairness: 3, clarity: 5, helpfulness: 3, preparation: 1, homework: 3, participation: 1, interesting: 2, attendance: 2  }, user_id: 1 }.to_json
    post("/fpo/1/Rutgers%20University%20-%20New%20Brunswick/Computer%20Science/Brian%20Russell/scores", vote, { "CONTENT_TYPE" => "application/json" })
    post("/fpo/1/Rutgers%20University%20-%20New%20Brunswick/Computer%20Science/Sesh%20Venugopal/scores", vote, { "CONTENT_TYPE" => "application/json" })
    post("/fpo/1/Rutgers%20University%20-%20New%20Brunswick/Math/Vladimir%20Shtelen/scores", vote, { "CONTENT_TYPE" => "application/json" })
    get "/fpo/1/Rutgers%20University%20-%20New%20Brunswick/departments"
    last_response.body.must_equal departments
  end
end

describe "Professors" do
  let(:professors){ { professors: ["brian russell", "sesh venugopal"]}.to_json}

  it "should return a list of CS professors" do
    DatabaseCleaner.clean
    vote = { score: { fairness: 3, clarity: 5, helpfulness: 3, preparation: 1, homework: 3, participation: 1, interesting: 2, attendance: 2  }, user_id: 1 }.to_json
    post("/fpo/1/Rutgers%20University%20-%20New%20Brunswick/Computer%20Science/Brian%20Russell/scores", vote, { "CONTENT_TYPE" => "application/json" })
    post("/fpo/1/Rutgers%20University%20-%20New%20Brunswick/Computer%20Science/Sesh%20Venugopal/scores", vote, { "CONTENT_TYPE" => "application/json" })
    post("/fpo/1/Rutgers%20University%20-%20New%20Brunswick/Math/Vladimir%20Shtelen/scores", vote, { "CONTENT_TYPE" => "application/json" })
    get "/fpo/1/Rutgers%20University%20-%20New%20Brunswick/Computer%20Science/professors"
    last_response.body.must_equal professors
  end
end


