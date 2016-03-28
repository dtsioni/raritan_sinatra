source 'https://rubygems.org'

gem "sinatra"
gem "json"
gem "rack-test", :group => :test
gem "activerecord"
gem "sinatra-activerecord"
gem "rake"
gem 'multi_json'

group :test do
  gem 'mocha', '~> 0.14.0', require: false
end

group :development, :test do
  gem 'sqlite3'
  gem 'database_cleaner'
end

group :production do
  gem 'pg'
end
