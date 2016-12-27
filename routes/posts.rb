get '/posts' do
  puts session[:username]

  # TODO: find the exact user by username
  # check if he is an admin
  # render the right view (with or without creating a blog posts)
  #
  erb :posts
end