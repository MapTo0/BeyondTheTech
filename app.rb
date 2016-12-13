require 'sinatra'
require "sinatra/activerecord"

set :database, {adapter: "sqlite3", database: "foo.sqlite3"}

require_relative 'models/users'
# More require statements...

require_relative 'routes/users'
# More require statements...

get '/' do
  'Hello world!'
end

get '/home' do
  erb :home
end