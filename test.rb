ENV['RACK_ENV'] = 'test'
require 'minitest/autorun'
require 'rack/test'
require_relative 'app.rb'

include Rack::Test::Methods

def app
  Sinatra::Application
end

describe "School" do
  it "should return json" do
    get '/rutgers'
    last_response.headers['Content-Type'].must_equal 'application/json'
  end

  it "should return the correct school" do
    get 'rutgers'
    school_info = { school: "rutgers"}
    last_response.body.must_equal school_info.to_json
  end
end
