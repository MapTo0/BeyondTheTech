get '/' do
  erb :home, locals: { texts: get_texts }
end

put '/' do
  language = params['language']
  session['lng'] = language
end