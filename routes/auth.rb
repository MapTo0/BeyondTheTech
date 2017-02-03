require 'pony'

get '/register' do
  erb :register, locals: { texts: get_texts }
end

get '/login' do
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
  password_hash = BCrypt::Password.create(password)

  user = User.create(email: email, username: username, password: password_hash, admin: false)

  p user.errors
  if user.saved?
    session[:user_id] = user.id
    status 200
  else
    status 403
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

put '/users/password' do
  user = User.get(session["user_id"])
  old_pass = params[:oldPassword]
  new_pass = params[:newPassword]

  if user.password == old_pass
    new_password_hash = BCrypt::Password.create(new_pass)
    user.update({ :password => new_password_hash })
    [200, session['lng']]
  else
    [403, session['lng']]
  end
end

post '/users/password' do
  mail = params[:email]
  user = User.first(:email => mail)
  unless user
    [401, session['lng']]
  else
    texts = get_texts
    random_password = Array.new(12).map { (65 + rand(58)).chr }.join
    password_hash = BCrypt::Password.create(random_password)
    user.password = password_hash
    user.save!
    email_body = "#{texts['AUTH_NEW_PASS']} " + random_password
    email_body += ". #{texts['AUTH_CONSIDER_CHANGE']}"

    Pony.mail :to => mail,
              :subject =>  'New Password',
              :body =>  email_body,
              :via => :smtp,
              :via_options => {
                  :address              => 'smtp.gmail.com',
                  :port                 => '587',
                  :enable_starttls_auto => true,
                  :user_name            => 'beyond.the.tech2017',
                  :password             => 'rubyFMI2017',
                  :authentication       => :plain,
                  :domain               => "localhost.localdomain"
                }
    [200, session['lng']]
  end
end