require 'sinatra'
require 'data_mapper'
require 'json'

DataMapper.setup(:default, ENV['DATABASE_URL'] || "sqlite3://#{Dir.pwd}/development.db")

require_relative 'helpers/auth_helper'
require_relative 'models/init'
require_relative 'routes/init'

set :root, File.dirname(__FILE__)

enable :sessions

DataMapper.auto_upgrade!
