require 'sinatra'
require 'data_mapper'

DataMapper.setup(:default, ENV['DATABASE_URL'] || "sqlite3://#{Dir.pwd}/development.db")

require_relative 'models/users'
require_relative 'routes/users'

require_relative 'routes/auth'

get '/' do
  erb :home
end

# DataMapper.auto_upgrade!

# User.create(email: "martin@abv.bg", username: "maPTo", password: "asdf", admin: false)

p User.all.each { |el| puts el }
