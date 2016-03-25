source 'https://rubygems.org'

gem "sinatra"
gem "json"
gem "rack-test", :group => :test
gem "activerecord"
gem "sinatra-activerecord"
gem "rake"

group :development, :test do
  gem 'sqlite3'
  gem 'database_cleaner'
end

group :production do
  gem 'pg'
end
