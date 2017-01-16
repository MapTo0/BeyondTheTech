get '/users' do
  @users = User.all

  @users.to_a.to_s
end