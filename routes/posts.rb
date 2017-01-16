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
  Post.all.to_a.to_s
end

get '/posts/view' do
end

get '/posts/:id' do
end

get '/posts/:id/view' do
end

post '/posts' do

  title = params[:title]
  body = params[:body]
  image_url = params[:imageUrl]
  post = Post.create(date: Time.now, active: true, title: title, body: body, imageURL: image_url)
  binding.pry

  Post.all.to_a.to_s
end