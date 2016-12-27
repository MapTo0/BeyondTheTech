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
    session[:username] = username
    puts 'redirecting'
    # redirect to('/posts')
  else
    status 403
  end
end

post '/login' do
  username = params['username']
  password = params['password']
  matching_user = User.first(:username => username)


  if matching_user && (matching_user.password == password)
    session[:username] = username
    # redirect to('/posts')
  else
    status 401
  end

end