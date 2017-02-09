require 'pony'

get '/register' do
  redirect_logged_users
  erb :register, locals: { texts: get_texts }
end

get '/login' do
  redirect_logged_users
  erb :login, locals: { texts: get_texts }
end

get '/logout' do
  session[:user_id] = nil
  redirect '/'
end

post '/register' do
  username = params['username']
  email = params['email']
  password = params['password']

  user = User.create(email: email,
                     username: username,
                     password: password,
                     admin: false
                     )

  if user.saved?
    session[:user_id] = user.id
    status 200
  else
    errors = []
    user.errors.instance_variable_get("@errors").to_h.each do |property|
      errors += property[1].map { |error| get_texts[error] }
    end

    halt 403, errors.compact
  end
end

post '/login' do
  username = params['username']
  password = params['password']
  matching_user = User.first(:username => username)

  if matching_user && (matching_user.password == password)
    session[:user_id] = matching_user.id
    status 200
  else
    status 401
  end
end