set(:admin) do |*roles|
  condition do
    unless user_admin?
      redirect "/", 303
    end
  end
end

get '/users', :admin => [:admin] do
  erb :users, locals: { texts: get_texts,
                        regulars: User.all(:admin => false),
                        admins: admins_except_current }
end

def admins_except_current
  User.all(:admin => true, :id.not => session[:user_id])
end

put '/user' do
  action = params[:action]
  user_id = params[:userId].to_i

  User.get(user_id).update({ :admin => (action == 'add') })
end

put '/user/password' do
  user = User.get(session["user_id"])
  old_pass = params[:oldPassword]
  new_pass = params[:newPassword]

  if user.password == old_pass
    user.update({ :password => new_pass })
    [200, session['lng']]
  else
    [403, session['lng']]
  end
end

post '/user/password' do
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

get '/user/profile' do
  check_auth_and_redirect
  erb :profile, locals: { texts: get_texts }
end

def admin? user_id
  current_user = User.get(user_id)
  current_user && current_user.admin
end

def user_admin?
  admin? session['user_id']
end

def logged? arg
  !!session['user_id']
end

def redirect_to_home
  redirect '/'
end

def check_auth_and_redirect
  unless session['user_id']
    redirect_to_home
  end
end
