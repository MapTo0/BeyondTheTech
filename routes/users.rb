get '/users' do
  erb :users, locals: { texts: get_texts, regulars: User.all(:admin => false), admins: User.all(:admin => true, :id.not => session[:user_id])}
end

put '/users' do
  action = params[:action]
  user_id = params[:userId].to_i

  User.get(user_id).update({ :admin => (action == 'add') })
end