# get '/posts' do
#   puts session[:username]

#   # TODO: find the exact user by username
#   # check if he is an admin
#   # render the right view (with or without creating a blog posts)
#   #
#   erb :posts
# end


require 'json'
require 'pry'

get '/posts' do
  p Post.all.to_a.to_s
end

get '/posts/view' do
end

get '/posts/:id/' do
  p 'here'
end

get '/posts/create' do
  username = session[:username]
  p User.first(:username => username)
  erb :create_post
end

get '/posts/:id/view' do
end

post '/posts' do
  title = params[:title]
  body = params[:body] # this will be a markdown
  image_url = params[:imageUrl]
  user = User.first(:username => session[:username])
  post = Post.create(date: Time.now, active: true, title: title, body: body, image_url: image_url)

  Post.all.to_a.to_s
end