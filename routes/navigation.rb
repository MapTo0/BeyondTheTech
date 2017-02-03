get '/profile' do
  erb :profile, locals: { texts: get_texts }
end