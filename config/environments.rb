configure :test do
  set :database, 'postgres:///raritan_test'
end

configure :development do
  set :database, 'postgres:///raritan_dev'
end

configure :production do
  db = URI.parse(ENV["DATABASE_URL"]) || URI.parse('postgres:///raritan_prod')
  ActiveRecord::Base.establish_connection(
    :adapter  => db.scheme == 'postgres' ? 'postgresql' : db.scheme,
    :host     => db.host,
    :username => db.user,
    :password => db.password,
    :database => db.path[1..-1],
    :encoding => 'utf8'
  )
end
