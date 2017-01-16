# get '/posts' do
#   puts session[:username]

#   # TODO: find the exact user by username
#   # check if he is an admin
#   # render the right view (with or without creating a blog posts)
#   #
#   erb :posts
# end

get '/posts' do
  # matches "GET /posts?title=foo&author=bar"
  # title = params['title']

  @post = Post.all[0]

  p @post.comments

  'wtf'
end

get '/posts/view' do
end

get '/posts/:id' do
end

get '/posts/:id/view' do
end

post '/posts' do
  post = Post.create(date: Time.now, active: true, title: "test Title", body: "Some body", imageURL: "http://google.bg")

  if post.saved?
    puts 'post savd'
  else
    puts 'fail'
  end
end