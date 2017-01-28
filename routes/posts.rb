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
require 'redcarpet'

get '/posts' do
end

get '/posts/view' do
  p Post.all
end

get '/posts/create' do
  erb :create_post
end

get '/posts/:id/view' do
  id = params[:id].to_i
  post = Post.get(id)

  renderer = Redcarpet::Render::HTML.new()
  markdown = Redcarpet::Markdown.new(renderer)

  erb :view_post, locals: { post: post, body: markdown.render(post.body), markdown_renderer: markdown }
end

post '/posts' do
  title = params[:title]
  body = params[:body] # this will be a markdown
  image_url = params[:imageUrl]
  user = User.first(:username => session[:username])
  tags = params[:tags].split(" ").uniq.map { |tag| Tag.first_or_new(text: tag) }

  post = Post.new(date: Time.now, active: true, title: title, body: body, image_url: image_url)

  tags.each { |tag| post.tags << tag }
  # post.user = user
  #

  post.save
  p post.errors
end

post '/posts/:id/comment' do
  user_id = params['userId'].to_i
  comment_text = params['text']
  user = User.get(user_id)
  post = Post.get(params[:id].to_i)

  comment = Comment.new(text: comment_text)
  comment.post = post
  comment.user = user

  comment.save
end