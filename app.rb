require 'sinatra'
require 'json'

get '/:school' do
  content_type :json
  school = params[:school]
  { school: school }.to_json
end
