get '/register' do
  erb :register
end

get '/login' do
  erb :login
end

post '/register' do
  username = params["username"]
  email = params["email"]
  password = params["password"]
  password_hash = BCrypt::Password.create(password)

  user = User.create(email: email, username: username, password: password_hash, admin: false)

  if user.saved?
    status 200
  else
    status 400
  end
end

post '/login' do
  username = params['username']
  password = params['password']
  matching_user = User.first(:username => username)

  if matching_user.password == password
    status 200
  else
    status 401
  end
end