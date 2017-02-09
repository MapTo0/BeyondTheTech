require 'sinatra'
require 'data_mapper'
require 'json'

DataMapper.setup(:default, 'postgres://zfpkaesmhhtqnm:6653b5c85e101735e9de648eb0b20a2c6aa5fbac8ed888292b50afec4c97c023@ec2-54-247-189-141.eu-west-1.compute.amazonaws.com:5432/da3i5f5db87j7s')

require_relative 'helpers/auth_helper'
require_relative 'models/init'
require_relative 'routes/init'

set :root, File.dirname(__FILE__)

enable :sessions

DataMapper.auto_upgrade!
