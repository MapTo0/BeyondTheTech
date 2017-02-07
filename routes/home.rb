get '/' do
  session['lng'] = session['lng'] || 'en'
  erb :home, locals: { texts: get_texts }
end

put '/' do
  language = params['language']
  session['lng'] = language
end

def get_texts
  session['lng'] = session['lng'] || 'en'
  texts = File.read('i18n/' + session['lng'] + '_texts.json')
  JSON.parse(texts)
end