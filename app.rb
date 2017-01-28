require 'sinatra'
require 'data_mapper'
require 'json'

DataMapper.setup(:default, ENV['DATABASE_URL'] || "sqlite3://#{Dir.pwd}/development.db")

require_relative 'models/init'

require_relative 'routes/users'
require_relative 'routes/auth'
require_relative 'routes/posts'

enable :sessions

get '/' do
  erb :home, locals: { texts: get_texts }
end

put '/' do
  language = params['language']
  session['lng'] = language
end

def get_texts
  language = session['lng'] || 'en'
  texts = File.read('internationalization/' + language + '_texts.json')
  JSON.parse(texts)
end

DataMapper.auto_upgrade!
