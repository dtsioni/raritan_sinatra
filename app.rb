require 'sinatra'
require 'sinatra/activerecord'
require './config/environments' #database configuration

get '/:school' do
  content_type :json
  school = params[:school]
  { school: school }.to_json
end
