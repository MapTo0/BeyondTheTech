set(:auth) do |*roles|
  condition do
    unless user_admin?
      redirect "/", 303
    end
  end
end

get '/users', :auth => [:admin] do
  erb :users, locals: { texts: get_texts, regulars: User.all(:admin => false), admins: User.all(:admin => true, :id.not => session[:user_id])}
end

put '/users' do
  action = params[:action]
  user_id = params[:userId].to_i

  User.get(user_id).update({ :admin => (action == 'add') })
end

def admin? user_id
  current_user = User.get(user_id)
  current_user && current_user.admin
end

def user_admin?
  admin? session['user_id']
end
